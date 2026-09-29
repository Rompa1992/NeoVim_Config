return {
    {
        -- LSP (clangd)
        -- Real C++ understanding: errors, go-to-definition, completion, inlay hints
        -- Use: gd          go to definition
        --      gD          go to declaration
        --      Space + h   switch between .h and .cpp
        --      Space + cf  format file
        --      Space + ci  toggle inlay hints
        "neovim/nvim-lspconfig",
        lazy = false,

        dependencies = {
            "mason-org/mason.nvim", -- Mason loads first, so clangd is found on PATH
            "saghen/blink.cmp",
        },

        config = function()
            vim.lsp.config("clangd", {
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=never",
                    "--completion-style=detailed",
                    -- Let clangd ask cross-compilers (ESP32 xtensa GCC via PlatformIO)
                    -- for their own system headers and target, instead of assuming MSVC
                    "--query-driver=**/xtensa-esp32-elf-*,C:/Users/Nathan/.platformio/packages/toolchain-*/bin/*",
                },
            })
            vim.lsp.enable("clangd")

            -- One shared group for format-on-save. Cleared per buffer on every attach (below),
            -- so re-attaching after Space + cr never adds a second formatter to the same file.
            local FormatGroup = vim.api.nvim_create_augroup("ZeroFormatOnSave", { clear = true })

            -- Formats the buffer with clangd only (never another LSP that might attach later),
            -- synchronously, so the file is fully formatted before it's written.
            local function format_buffer(Buffer)
                vim.lsp.buf.format({
                    bufnr = Buffer,
                    async = false,
                    timeout_ms = 2000,
                    filter = function(Client)
                        return Client.name == "clangd"
                    end,
                })
            end

            -- Keymaps, inlay hints and format-on-save for buffers where an LSP is attached
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
                    map("<leader>cf", function()
                        format_buffer(args.buf)
                    end, "Format file")

                    -- Inlay hints: parameter names and deduced types shown dimly inside the code (off by default)
                    vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })

                    map("<leader>ci", function()
                        local bEnabled = vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf })
                        vim.lsp.inlay_hint.enable(not bEnabled, { bufnr = args.buf })
                    end, "Toggle inlay hints")

                    -- Format with .clang-format every time the file is saved.
                    -- Remove this buffer's previous format-on-save first, so there is always exactly one.
                    vim.api.nvim_clear_autocmds({ group = FormatGroup, buffer = args.buf })
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = FormatGroup,
                        buffer = args.buf,
                        callback = function()
                            format_buffer(args.buf)
                        end,
                    })
                end,
            })
        end,
    },
}
