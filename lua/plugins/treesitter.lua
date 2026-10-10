return {
    {
        -- Treesitter
        -- Better syntax highlighting and C++ code parsing
        -- Use: :TSInstall cpp
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",

        config = function()
            -- Parsers installed on first start, so a fresh machine needs no :TSInstall
            require("nvim-treesitter").install({ "cpp", "c", "lua", "cmake", "markdown", "markdown_inline" })

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("ZeroTreesitterStart", { clear = true }),
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    },
}
