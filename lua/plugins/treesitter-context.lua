return {
    {
        -- Treesitter context
        -- Pins the enclosing function / for / if lines to the top when you scroll past them
        -- Use: [x   jump up to the pinned line
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },

        opts = {
            mode = "topline",  -- based on what has scrolled off the top
            max_lines = 0,     -- no limit: never drop a parent
        },

        config = function(_, opts)
            require("treesitter-context").setup(opts)

            vim.keymap.set("n", "[x", function()
                require("treesitter-context").go_to_context()
            end, { desc = "Jump to context" })
        end,
    },
}
