return {
    {
        -- Gitsigns
        -- Shows added / changed / deleted lines in the gutter
        -- Use: ]h / [h      next / previous change
        --      Space + gp   preview the change under the cursor
        --      Space + gb   who last changed this line (blame)
        --      Space + gr   undo (reset) the change under the cursor
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },

        opts = {
            on_attach = function(bufnr)
                local gs = require("gitsigns")

                local map = function(keys, fn, desc)
                    vim.keymap.set("n", keys, fn, { buffer = bufnr, desc = desc })
                end

                map("]h", function() gs.nav_hunk("next") end, "Next git change")
                map("[h", function() gs.nav_hunk("prev") end, "Previous git change")
                map("<leader>gp", gs.preview_hunk, "Preview change")
                map("<leader>gb", gs.blame_line, "Blame line")
                map("<leader>gr", gs.reset_hunk, "Reset change")
            end,
        },
    },
}
