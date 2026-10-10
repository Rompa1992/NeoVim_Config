-- =====================================================================
-- General
-- =====================================================================

-- F2: toggle file tree, from Normal or Insert mode
vim.keymap.set({ "n", "i" }, "<F2>", function()
    vim.cmd("stopinsert") -- leave Insert first, so keys in the tree move instead of typing
    vim.cmd("Neotree toggle")
end, { desc = "File tree" })

-- jj in Insert mode returns to Normal mode
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode" })

-- Ctrl+Right: next word, but stop at the end of the line instead of wrapping to the next one
local function WordRightInLine()
    local Row = vim.api.nvim_win_get_cursor(0)[1]
    vim.cmd("normal! w")
    if vim.api.nvim_win_get_cursor(0)[1] ~= Row then
        local LineLength = #vim.api.nvim_buf_get_lines(0, Row - 1, Row, false)[1]
        local bInsertMode = vim.api.nvim_get_mode().mode == "i"
        local EndCol = bInsertMode and LineLength or math.max(LineLength - 1, 0) -- Insert can sit past the last character
        vim.api.nvim_win_set_cursor(0, { Row, EndCol })
    end
end
vim.keymap.set({ "n", "i" }, "<C-Right>", WordRightInLine, { desc = "Next word (stay on line)" })

-- Ctrl+Left: previous word, but stop at the start of the line instead of wrapping to the one above
local function WordLeftInLine()
    local Row = vim.api.nvim_win_get_cursor(0)[1]
    vim.cmd("normal! b")
    if vim.api.nvim_win_get_cursor(0)[1] ~= Row then
        vim.api.nvim_win_set_cursor(0, { Row, 0 })
    end
end
vim.keymap.set({ "n", "i" }, "<C-Left>", WordLeftInLine, { desc = "Previous word (stay on line)" })

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

-- Ctrl+V with a selection: replace it with the clipboard. Unmapped, Ctrl+V switches to block selection.
-- "_ sends the replaced text to the black hole register, so it doesn't overwrite what you copied.
vim.keymap.set("x", "<C-v>", '"_c<C-r><C-o>+', { desc = "Paste over selection" })

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
-- Never saves or reloads your files: unsaved changes stay exactly as they are
vim.keymap.set("n", "<leader>cr", function()
    vim.lsp.stop_client(vim.lsp.get_clients({ name = "clangd" }))
    vim.notify("Restarting clangd...", vim.log.levels.INFO)

    -- Once it has stopped, re-run each C/C++ buffer's FileType event: vim.lsp.enable starts clangd on it again
    vim.defer_fn(function()
        for _, Buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_loaded(Buf) and vim.tbl_contains({ "c", "cpp" }, vim.bo[Buf].filetype) then
                vim.api.nvim_exec_autocmds("FileType", { buffer = Buf })
            end
        end
    end, 500)
end, { desc = "Restart clangd" })

-- Move lines up and down with Alt+arrows
vim.keymap.set("n", "<A-Down>", "<cmd>m .+1<cr>", { desc = "Move line down" })
vim.keymap.set("n", "<A-Up>", "<cmd>m .-2<cr>", { desc = "Move line up" })
vim.keymap.set("i", "<A-Down>", "<esc><cmd>m .+1<cr>gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-Up>", "<esc><cmd>m .-2<cr>gi", { desc = "Move line up" })
vim.keymap.set("v", "<A-Down>", ":m '>+1<cr>gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-Up>", ":m '<-2<cr>gv", { desc = "Move selection up" })
