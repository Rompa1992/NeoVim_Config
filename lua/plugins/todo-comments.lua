return {
    {
        -- Todo comments
        -- Highlights TODO / FIXME / HACK / NOTE / PERF / WARN / TEST, plus our own NET and TEMP
        -- Use: ]t / [t      next / previous tagged comment
        --      Space + ft   search all tagged comments in the project
        "folke/todo-comments.nvim",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },

        opts = function()
            local c = require("config.palette")

            return {
                -- Extra tags (the built-in ones are kept)
                keywords = {
                    NET  = { icon = "⇄ ", color = "net" },   -- co-op / networking concerns
                    TEMP = { icon = "◌ ", color = "temp" },  -- temporary code to remove
                },

                -- Colours for each tag type, from the palette
                colors = {
                    error   = { c.red },               -- FIXME, BUG
                    warning = { c.directive_orange },  -- HACK, WARN
                    info    = { c.string_yellow },     -- TODO
                    hint    = { c.prussian_light },    -- NOTE
                    default = { c.macro_purple },      -- PERF
                    test    = { c.muted_green },       -- TEST
                    net     = { c.mode_insert },       -- NET
                    temp    = { c.gray },              -- TEMP
                },
            }
        end,

        keys = {
            { "]t", function() require("todo-comments").jump_next() end, desc = "Next tagged comment" },
            { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous tagged comment" },
            { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find tagged comments" },
        },
    },
}
