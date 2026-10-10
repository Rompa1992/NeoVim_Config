return {
    {
        -- LSP (clangd)
        -- Real C++ understanding: errors, go-to-definition, completion, inlay hints
        -- Formatting NEVER runs automatically. Only Space + cf formats, and only when you press it.
        -- Use: gd          go to definition
        --      gD          go to declaration
        --      Space + h   switch between .h and .cpp
        --      Space + cf  format file (manual only)
        --      Space + ci  toggle inlay hints
        "neovim/nvim-lspconfig",
        lazy = false,

        dependencies = {
            "mason-org/mason.nvim", -- Mason loads first, so clangd is found on PATH
            "saghen/blink.cmp",
        },

        config = function()
            vim.lsp.config("clangd", {
                -- Tells clangd blink can expand snippets, so accepting a function fills in its parameters
                capabilities = require("blink.cmp").get_lsp_capabilities(),
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=never",
                    "--completion-style=detailed",
                    -- Accepting a function fills in its parameters as fields: Tab jumps to the next one
                    "--function-arg-placeholders=1",
                    -- Let clangd ask cross-compilers (ESP32 xtensa GCC via PlatformIO)
                    -- for their own system headers and target, instead of assuming MSVC
                    "--query-driver=**/xtensa-esp32-elf-*,C:/Users/Nathan/.platformio/packages/toolchain-*/bin/*",
                },
            })
            vim.lsp.enable("clangd")

            -- Keymaps and inlay hints for buffers where clangd is attached
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local Client = vim.lsp.get_client_by_id(args.data.client_id)
                    if not Client or Client.name ~= "clangd" then
                        return
                    end

                    local map = function(keys, fn, desc)
                        vim.keymap.set("n", keys, fn, { buffer = args.buf, desc = desc })
                    end

                    map("<leader>h", "<cmd>LspClangdSwitchSourceHeader<CR>", "Switch .h/.cpp")
                    map("gd", vim.lsp.buf.definition, "Go to definition")
                    map("gD", vim.lsp.buf.declaration, "Go to declaration")

                    -- Format now. The only way formatting ever runs (conform.lua)
                    map("<leader>cf", function()
                        require("conform").format({ bufnr = args.buf, timeout_ms = 2000, lsp_format = "fallback" })
                    end, "Format file")

                    -- Inlay hints: parameter names and deduced types shown dimly inside the code (off by default)
                    vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })

                    map("<leader>ci", function()
                        local bEnabled = vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf })
                        vim.lsp.inlay_hint.enable(not bEnabled, { bufnr = args.buf })
                    end, "Toggle inlay hints")
                end,
            })

            -- clangd sends the same token type for classes and structs ("class"), and for their
            -- members ("property"). Split them by ZeroEngine's naming rule: C + capital = class.
            -- C classes and T classes (TFixedString, TFixedArray) keep private data, so their members share a colour
            local function IsClassName(Name)
                return Name ~= nil and (Name:match("^C%u") ~= nil or Name:match("^T%u") ~= nil)
            end

            -- Name declared by a declarator: Other in "CWindow&& Other", Window in "CWindow Window{}".
            local function GetDeclaredName(Declarator, Bufnr)
                while Declarator and Declarator:type() ~= "identifier" do
                    -- reference_declarator has no "declarator" field, so fall back to its last named child
                    Declarator = Declarator:field("declarator")[1]
                        or Declarator:named_child(Declarator:named_child_count() - 1)
                end
                return Declarator and vim.treesitter.get_node_text(Declarator, Bufnr)
            end

            -- True if a declaration's type is a C class: CWindow, Zero::CWindow, or auto = CWindow...
            local function IsClassDeclaration(Declaration, Declarator, Bufnr)
                local TypeNode = Declaration:field("type")[1]
                if not TypeNode then
                    return false
                end

                local Text = vim.treesitter.get_node_text(TypeNode, Bufnr)
                if Text == "auto" and Declarator:type() == "init_declarator" then
                    local Value = Declarator:field("value")[1]
                    Text = Value and vim.treesitter.get_node_text(Value, Bufnr):match("^[%w_:]+") or ""
                end
                return IsClassName((Text:gsub("^Zero::", "")))
            end

            -- True if Name, used on UseRow inside Function, was declared there as a C class.
            -- Searches parameters and locals; the last declaration before the use wins.
            local function IsClassObject(Function, Name, UseRow, Bufnr)
                local bIsClass = false
                local function Walk(Node)
                    for Child in Node:iter_children() do
                        if Child:named() then
                            local Type = Child:type()
                            if (Type == "parameter_declaration" or Type == "optional_parameter_declaration"
                                    or Type == "declaration" or Type == "for_range_loop")
                                and Child:start() <= UseRow then
                                for _, Declarator in ipairs(Child:field("declarator")) do
                                    if GetDeclaredName(Declarator, Bufnr) == Name then
                                        bIsClass = IsClassDeclaration(Child, Declarator, Bufnr)
                                    end
                                end
                            end
                            Walk(Child)
                        end
                    end
                end
                Walk(Function)
                return bIsClass
            end

            -- True if the member at Line, Col belongs to a C class, judged with tree-sitter:
            -- declared inside a C class, used inside a C class's member function, this->Member,
            -- or Object.Member where Object is a parameter or local declared as a C class.
            -- Objects whose type only clangd knows, like GetWindow().Member, stay struct blue.
            local function IsClassMember(Bufnr, Line, Col)
                local Ok, Node = pcall(vim.treesitter.get_node, { bufnr = Bufnr, pos = { Line, Col }, ignore_injections = true })
                if not Ok or not Node then
                    return false
                end

                local Parent = Node:parent()
                if Parent and Parent:type() == "field_expression" and Parent:field("field")[1] == Node then
                    local Object = Parent:field("argument")[1]
                    if not Object then
                        return false
                    end
                    if Object:type() == "this" then
                        return true
                    end
                    if Object:type() == "identifier" then
                        local Function = Parent:parent()
                        while Function and Function:type() ~= "function_definition" do
                            Function = Function:parent()
                        end
                        local Name = vim.treesitter.get_node_text(Object, Bufnr)
                        return Function ~= nil and IsClassObject(Function, Name, Line, Bufnr)
                    end
                    return false
                end

                local Current = Node
                while Current do
                    local Type = Current:type()
                    if Type == "class_specifier" or Type == "struct_specifier" then
                        local NameNode = Current:field("name")[1]
                        return NameNode ~= nil and IsClassName(vim.treesitter.get_node_text(NameNode, Bufnr))
                    end
                    if Type == "function_definition" then
                        -- Out-of-class member function, such as CWindow::GetSize
                        local Declarator = Current:field("declarator")[1]
                        while Declarator and Declarator:type() ~= "function_declarator" do
                            -- reference_declarator (CRenderer& CRenderer::operator=) has no "declarator" field
                            Declarator = Declarator:field("declarator")[1]
                                or Declarator:named_child(Declarator:named_child_count() - 1)
                        end
                        local Name = Declarator and Declarator:field("declarator")[1]
                        if Name and Name:type() == "qualified_identifier" then
                            local Scope = Name:field("scope")[1]
                            return Scope ~= nil and IsClassName(vim.treesitter.get_node_text(Scope, Bufnr))
                        end
                    end
                    Current = Current:parent()
                end
                return false
            end

            vim.api.nvim_create_autocmd("LspTokenUpdate", {
                callback = function(Args)
                    local Token = Args.data.token

                    local IsTypeToken = Token.type == "class" or Token.type == "type"
                    local Name = ""
                    if IsTypeToken then
                        local Line = vim.api.nvim_buf_get_lines(Args.buf, Token.line, Token.line + 1, false)[1] or ""
                        Name = Line:sub(Token.start_col + 1, Token.end_col)
                    end

                    if IsTypeToken and Name:match("^T%u") then
                        -- T types (TArray, TFixedArray, TUniquePtr): their own colour, so TArray<int32> isn't all one blue
                        vim.lsp.semantic_tokens.highlight_token(Token, Args.buf, Args.data.client_id, "@lsp.zero.template")
                    elseif Token.type == "class" then
                        local Group = IsClassName(Name) and "@lsp.zero.class" or "@lsp.zero.struct"
                        vim.lsp.semantic_tokens.highlight_token(Token, Args.buf, Args.data.client_id, Group)
                    elseif Token.type == "property" then
                        if IsClassMember(Args.buf, Token.line, Token.start_col) then
                            vim.lsp.semantic_tokens.highlight_token(Token, Args.buf, Args.data.client_id, "@lsp.zero.classmember")
                        end
                    end
                end,
            })
        end,
    },
}
