return {
    {
        -- Telescope
        -- Fast file/project search
        -- Use: Space + f + f  find files
        --      Space + f + g  search text across the project (needs ripgrep)
        --      Space + f + w  search the word under the cursor
        --      Space + f + b  switch between open files
        --      Space + f + s  list symbols in the current file (needs clangd)
        "nvim-telescope/telescope.nvim",

        dependencies = {
            "nvim-lua/plenary.nvim",
        },

        config = function()
            local map = vim.keymap.set

            map("n", "<leader>ff", "<cmd>Telescope find_files<CR>",           { desc = "Find files" })
            map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",            { desc = "Search text in project" })
            map("n", "<leader>fw", "<cmd>Telescope grep_string<CR>",          { desc = "Search word under cursor" })
            map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",              { desc = "Open buffers" })
            map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Symbols in file" })
        end,
    },
}
