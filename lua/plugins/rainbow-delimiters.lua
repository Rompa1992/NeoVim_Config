return {
    {
        -- Rainbow delimiters
        -- Colours nested brackets by depth, using the muted theme colours
        -- (colours are defined in colorscheme.lua under "Rainbow brackets")
        -- Outermost level is orange, matching the brackets you already have
        "HiPhish/rainbow-delimiters.nvim",
        event = { "BufReadPost", "BufNewFile" },

        init = function()
            vim.g.rainbow_delimiters = {
                highlight = {
                    "RainbowDelimiterOrange",  -- level 1: orange
                    "RainbowDelimiterBlue",    -- level 2: light Prussian
                    "RainbowDelimiterGreen",   -- level 3: muted olive
                    "RainbowDelimiterRed",     -- level 4: dusty red
                    "RainbowDelimiterViolet",  -- level 5: muted pink
                    "RainbowDelimiterCyan",    -- level 6: beige
                },
            }
        end,
    },
}
