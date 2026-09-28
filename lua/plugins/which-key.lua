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
                mappings = false,  -- no icons next to keys (no Nerd Font needed)
            },

            -- Group names shown in the popup
            spec = {
                { "<leader>f", group = "Find (Telescope)" },
                { "<leader>d", group = "Debug" },
                { "<leader>c", group = "Code" },
                { "<leader>g", group = "Git" },
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
