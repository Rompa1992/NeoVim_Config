return {
    {
        -- Telescope
        -- Fast file/project search
        -- Use: Space + f + f  find files
        --      Space + f + g  search text across the project (needs ripgrep)
        --      Space + f + w  search the word under the cursor
        --      Space + f + b  switch between open files
        --      Space + f + s  list symbols in the current file (needs clangd)
        --      Space + f + S  search symbols across the whole project (needs clangd)
        --      Space + f + u  usages: every reference to the symbol under the cursor
        --      Space + f + o  recently opened files
        --      Space + f + l  reopen the last search, as you left it
        --      Space + f + h  search Neovim's help
        --      Space + f + k  search every keymap
        "nvim-telescope/telescope.nvim",

        dependencies = {
            "nvim-lua/plenary.nvim",

            -- Faster, smarter fuzzy matching. Compiled once by CMake when installed or updated.
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
            },
        },

        config = function()
            -- pcall: if the fzf build ever fails, Telescope still works with its default matcher
            pcall(require("telescope").load_extension, "fzf")

            local map = vim.keymap.set

            map("n", "<leader>ff", "<cmd>Telescope find_files<CR>",           { desc = "Find files" })
            map("n", "<leader>fg", "<cmd>Telescope live_grep<CR>",            { desc = "Search text in project" })
            map("n", "<leader>fw", "<cmd>Telescope grep_string<CR>",          { desc = "Search word under cursor" })
            map("n", "<leader>fb", "<cmd>Telescope buffers<CR>",              { desc = "Open buffers" })
            map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Symbols in file" })
            map("n", "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "Symbols in project" })
            map("n", "<leader>fu", "<cmd>Telescope lsp_references<CR>",                { desc = "Usages of symbol" })
            map("n", "<leader>fo", "<cmd>Telescope oldfiles<CR>",                      { desc = "Recent files" })
            map("n", "<leader>fl", "<cmd>Telescope resume<CR>",                        { desc = "Last search, resumed" })
            map("n", "<leader>fh", "<cmd>Telescope help_tags<CR>",                     { desc = "Help" })
            map("n", "<leader>fk", "<cmd>Telescope keymaps<CR>",                       { desc = "Keymaps" })
        end,
    },
}
