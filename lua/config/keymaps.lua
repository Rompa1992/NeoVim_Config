-- =====================================================================
-- General
-- =====================================================================

-- F2: toggle file tree
vim.keymap.set("n", "<F2>", "<Cmd>Neotree toggle<CR>", { desc = "File tree" })

-- jk in Insert mode returns to Normal mode
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode" })

-- Esc in Normal mode: clear search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- =====================================================================
-- Editing (VS Code style)
-- =====================================================================

-- Ctrl+A in Insert mode: select entire file
vim.keymap.set("i", "<C-a>", "<Esc>ggVG", { desc = "Select all" })

-- Ctrl+Z in Insert mode: undo, stay in Insert mode
vim.keymap.set("i", "<C-z>", "<C-o>u", { desc = "Undo" })

-- Ctrl+C / Ctrl+X with a selection: copy / cut to system clipboard
vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copy selection" })
vim.keymap.set("v", "<C-x>", '"+d', { desc = "Cut selection" })

-- Ctrl+C / Ctrl+X in Insert mode: copy / cut the current line
vim.keymap.set("i", "<C-c>", '<C-o>"+yy', { desc = "Copy line" })
vim.keymap.set("i", "<C-x>", '<C-o>"+dd', { desc = "Cut line" })

-- Ctrl+V in Insert mode: paste from system clipboard
-- If the line only contains auto-indent spaces, clear them first so the paste isn't shifted right
vim.keymap.set("i", "<C-v>", function()
    local bLineIsBlank = vim.api.nvim_get_current_line():match("^%s*$") ~= nil
    if bLineIsBlank then
        return "0<C-d><C-r><C-o>+"
    end
    return "<C-r><C-o>+"
end, { expr = true, desc = "Paste" })

-- Ctrl+Backspace in Insert mode: delete the previous word
-- (terminals send it as either <C-BS> or <C-h>, so map both)
vim.keymap.set("i", "<C-BS>", "<C-w>", { desc = "Delete previous word" })
vim.keymap.set("i", "<C-h>", "<C-w>", { desc = "Delete previous word" })

-- =====================================================================
-- Indenting
-- =====================================================================

-- Shift+Tab in Insert mode: unindent the line
vim.keymap.set("i", "<S-Tab>", "<C-d>", { desc = "Unindent" })

-- Tab / Shift+Tab with a selection: indent / unindent and keep the selection
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selection" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "Unindent selection" })

-- =====================================================================
-- Terminal and windows
-- =====================================================================

-- Esc Esc in a terminal window: back to normal mode (single Esc still goes to the program)
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Leave terminal mode" })

-- Ctrl + h/j/k/l: move between windows (left/down/up/right)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Space + cr: restart clangd (after adding files or changing CMake)
vim.keymap.set("n", "<leader>cr", function()
    vim.cmd("wall") -- save first, so reopening the file loses nothing
    vim.lsp.stop_client(vim.lsp.get_clients({ bufnr = 0 }))
    vim.notify("Restarting clangd...", vim.log.levels.INFO)

    -- Reopen the file after clangd has stopped; clangd re-attaches automatically
    vim.defer_fn(function()
        vim.cmd("edit")
    end, 500)
end, { desc = "Restart clangd" })
