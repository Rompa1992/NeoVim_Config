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
            "mason-org/mason.nvim",  -- Mason loads first, so clangd is found on PATH
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
                    "--query-driver=**/xtensa-esp32-elf-*,C:/Users/Nathan/.platformio/packages/toolchain-*/bin/*",
                    -- Let clangd ask cross-compilers (ESP32 xtensa GCC via PlatformIO)
                    -- for their own system headers and target, instead of assuming MSVC
                    "--query-driver=**/xtensa-esp32-elf-*,C:/Users/Nathan/.platformio/packages/toolchain-*/bin/*",
                },
            })
            vim.lsp.enable("clangd")

            -- Keymaps, inlay hints and format-on-save for buffers where an LSP is attached
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local map = function(keys, fn, desc)
                        vim.keymap.set("n", keys, fn, { buffer = args.buf, desc = desc })
                    end

                    map("<leader>h", "<cmd>LspClangdSwitchSourceHeader<CR>", "Switch .h/.cpp")
                    map("gd", vim.lsp.buf.definition, "Go to definition")
                    map("gD", vim.lsp.buf.declaration, "Go to declaration")
                    map("<leader>cf", vim.lsp.buf.format, "Format file")

                    -- Inlay hints: parameter names and deduced types shown dimly inside the code
                    vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })

                    map("<leader>ci", function()
                        local bEnabled = vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf })
                        vim.lsp.inlay_hint.enable(not bEnabled, { bufnr = args.buf })
                    end, "Toggle inlay hints")

                    -- Format with .clang-format every time the file is saved
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = args.buf,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = args.buf })
                        end,
                    })
                end,
            })
        end,
    },
}
