return {
    {
        -- Aerial
        -- Outline of the current file in a side panel: namespaces, classes, structs, functions, members
        -- Use: Space + o    toggle the outline
        --      Enter        jump to the symbol, the outline follows the cursor
        "stevearc/aerial.nvim",

        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },

        opts = {
            backends = { "lsp", "treesitter" }, -- clangd first, tree-sitter when clangd isn't attached

            -- Field is added to the defaults, so struct members show up too
            filter_kind = { "Class", "Constructor", "Enum", "Field", "Function", "Method", "Namespace", "Struct" },
        },

        keys = {
            { "<leader>o", "<cmd>AerialToggle!<CR>", desc = "File outline" },
        },
    },
}
