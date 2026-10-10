return {
    {
        -- Grug-far
        -- Find and replace across the whole project, previewing every change before it's made
        -- Use: Space + fr   open it: type the search, then the replacement; results update as you type
        --                   in Visual mode, it opens searching for the selection
        --      In its window: Space + r   replace everything shown
        --                     g?          list its other keys
        "MagicDuck/grug-far.nvim",
        cmd = "GrugFar",
        opts = {},

        keys = {
            { "<leader>fr", function() require("grug-far").open() end, desc = "Find and replace in project" },
            {
                "<leader>fr",
                function() require("grug-far").with_visual_selection() end,
                mode = "x",
                desc = "Find and replace the selection",
            },
        },
    },
}
