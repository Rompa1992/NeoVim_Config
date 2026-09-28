
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
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    pcall(vim.treesitter.start)
                end,
            })
        end,
    },
}
