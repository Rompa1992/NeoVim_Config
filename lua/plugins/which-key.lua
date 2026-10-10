return {
    {
        -- Which-key
        -- Pops up a menu of available keys after you press Space (or any prefix) and pause
        -- Use: Space           wait a moment to see your Space shortcuts
        --      Space + w       show ALL keymaps
        "folke/which-key.nvim",
        event = "VeryLazy",

        opts = {
            preset = "classic",
            delay = 400,  -- ms to wait before the popup appears

            icons = {
                mappings = true,   -- icons next to keys (needs the Nerd Font)
            },

            -- Group names shown in the popup
            spec = {
                { "<leader>f", group = "Find (Telescope)" },
                { "<leader>d", group = "Debug" },
                { "<leader>c", group = "Code" },
                { "<leader>g", group = "Git" },
                { "<leader>q", group = "Session" },
                { "<leader>e", group = "Errors (Trouble)" },
            },
        },

        keys = {
            {
                "<leader>w",
                function()
                    require("which-key").show({ global = true })
                end,
                desc = "Show all keymaps",
            },
        },
    },
}
