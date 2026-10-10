return {
    {
        -- Trouble
        -- A clean list of errors, warnings and build errors, grouped by file
        -- Use: Space + ee   all errors and warnings in the project
        --      Space + eb   errors and warnings in this file only
        --      Space + eq   build errors (the quickfix list from Space b)
        --      Enter on an entry jumps to it, q closes the list
        "folke/trouble.nvim",
        cmd = "Trouble",
        opts = {},

        keys = {
            { "<leader>ee", "<cmd>Trouble diagnostics toggle<CR>", desc = "All errors and warnings" },
            { "<leader>eb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Errors in this file" },
            { "<leader>eq", "<cmd>Trouble qflist toggle<CR>", desc = "Build errors" },
        },
    },
}
