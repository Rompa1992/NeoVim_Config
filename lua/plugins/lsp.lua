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

                    -- Manual formatting only
                    map("<leader>cf", function()
                        vim.lsp.buf.format({
                            bufnr = args.buf,
                            async = false,
                            timeout_ms = 2000,
                            filter = function(FormatClient)
                                return FormatClient.name == "clangd"
                            end,
                        })
                    end, "Format file")

                    -- Inlay hints: parameter names and deduced types shown dimly inside the code (off by default)
                    vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })

                    map("<leader>ci", function()
                        local bEnabled = vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf })
                        vim.lsp.inlay_hint.enable(not bEnabled, { bufnr = args.buf })
                    end, "Toggle inlay hints")
                end,
            })
        end,
    },
}
