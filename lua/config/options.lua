-- Space is the leader key for custom shortcuts
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.fileformats = "unix,dos"   -- new files use LF; existing files keep whatever they have

-- =============================================================================
-- Display
-- =============================================================================
vim.opt.termguicolors = true    -- full 24-bit colour
vim.opt.number = true           -- line numbers
vim.opt.relativenumber = false  -- absolute numbers only
vim.opt.signcolumn = "yes"      -- always keep a column for signs, so text doesn't shift
vim.opt.cursorline = true       -- highlight the current line
vim.opt.scrolloff = 8           -- keep 8 lines above/below the cursor (stays clear of pinned context)
vim.opt.colorcolumn = "120"     -- vertical guide at the .clang-format line limit
vim.opt.winborder = "rounded"   -- rounded borders on popups (hover, diagnostics)

-- =============================================================================
-- Indentation: 4 spaces
-- =============================================================================
vim.opt.tabstop = 4             -- a tab character displays as 4 wide
vim.opt.shiftwidth = 4          -- >>, <<, and auto-indent use 4
vim.opt.softtabstop = 4         -- Tab / Backspace move by 4 in insert mode
vim.opt.expandtab = true        -- Tab inserts spaces, not a tab character
vim.opt.smartindent = true      -- auto-indent new lines after {

-- =============================================================================
-- Build
-- =============================================================================
-- Build command used by :make (runs from Neovim's working directory)
vim.opt.makeprg = "cmake --build build"
