return {
    {
        -- Surround
        -- Add, change or delete the brackets, quotes or tags around text
        -- Use: ysiw)   surround the word with ( )          ys + motion + the character
        --      yss"    surround the whole line with " "
        --      ds"     delete the " " around the cursor
        --      cs'"    change the ' ' around the cursor to " "
        --      gs)     in Visual mode: surround the selection with ( )
        "kylechui/nvim-surround",
        version = "^4.0.0",
        event = "VeryLazy",

        init = function()
            -- Flash already uses S in Visual mode, so surrounding a selection moves to gs
            vim.g.nvim_surround_no_visual_mappings = true
        end,

        config = function()
            require("nvim-surround").setup({})
            vim.keymap.set("x", "gs", "<Plug>(nvim-surround-visual)", { desc = "Surround selection" })
            vim.keymap.set("x", "gS", "<Plug>(nvim-surround-visual-line)", { desc = "Surround selection, on new lines" })
        end,
    },
}
