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
-- Build and run
-- =====================================================================

-- Space + b: save all, build Debug, open the error list if there are errors
vim.keymap.set("n", "<leader>b", "<cmd>wall<CR><cmd>silent make!<CR><cmd>cwindow<CR>", { desc = "Build Debug" })

-- Space + B (capital): save all, build Release
vim.keymap.set("n", "<leader>B", function()
    vim.cmd("wall")
    vim.opt.makeprg = "cmake --build build-release"
    vim.cmd("silent make!")
    vim.opt.makeprg = "cmake --build build" -- switch back to Debug for Space + b
    vim.cmd("cwindow")
end, { desc = "Build Release" })

-- The run terminal: ONE window at the bottom, reused by every Space r / Space t.
-- Remembered here so the next run finds it instead of opening another split.
local RunWindow = nil
local RunBuffer = nil

local function run_in_terminal(exe)
    -- Reuse the run window if it's still open; otherwise open a new one at the bottom
    if RunWindow ~= nil and vim.api.nvim_win_is_valid(RunWindow) then
        vim.api.nvim_set_current_win(RunWindow)
    else
        vim.cmd("botright split")
        vim.cmd("resize 12")
        RunWindow = vim.api.nvim_get_current_win()
    end

    local OldBuffer = RunBuffer

    -- Start the program in this window (creates a new terminal buffer)
    vim.cmd('terminal "' .. exe .. '"') -- quotes: path has spaces
    RunBuffer = vim.api.nvim_get_current_buf()

    -- Unlisted = not shown as a tab in the tab bar, skipped by :bnext
    vim.bo[RunBuffer].buflisted = false

    -- Throw away the previous run's terminal (force: stops it if it's still running)
    if OldBuffer ~= nil and OldBuffer ~= RunBuffer and vim.api.nvim_buf_is_valid(OldBuffer) then
        vim.api.nvim_buf_delete(OldBuffer, { force = true })
    end
end

local function build_and_run(exe_name)
    vim.cmd("wall")
    vim.cmd("silent make!")

    if vim.v.shell_error ~= 0 then
        vim.cmd("copen") -- build failed: show errors, don't run
        return
    end

    local exe = require("config.project").find_exe("build", exe_name)
    if not exe then
        vim.notify("No " .. exe_name .. ".exe found in build/", vim.log.levels.ERROR)
        return
    end

    vim.cmd("cclose")
    run_in_terminal(exe)
end

-- Space + r: save all, build Debug, run Game.exe in the run window (only if the build succeeded)
vim.keymap.set("n", "<leader>r", function()
    build_and_run("Game")
end, { desc = "Build and run" })

-- Space + t: save all, build Debug, run ZeroTests.exe in the run window (only if the build succeeded)
vim.keymap.set("n", "<leader>t", function()
    build_and_run("ZeroTests")
end, { desc = "Build and run ZeroTests" })

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
