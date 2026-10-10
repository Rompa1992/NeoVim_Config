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
vim.opt.splitright = true       -- vertical splits open on the right
vim.opt.splitbelow = true       -- horizontal splits open below

-- =============================================================================
-- Editing
-- =============================================================================
vim.opt.undofile = true         -- undo history survives closing and reopening a file
vim.opt.ignorecase = true       -- search ignores case...
vim.opt.smartcase = true        -- ...unless the search has a capital letter
vim.opt.updatetime = 250        -- ms of no typing before CursorHold fires (default 4000)

-- Enter, o and O never continue a comment onto the new line.
-- Filetype plugins turn it back on per buffer, so it's removed after they run.
vim.api.nvim_create_autocmd("FileType", {
    callback = function(Args)
        vim.schedule(function()
            if vim.api.nvim_buf_is_valid(Args.buf) then
                vim.bo[Args.buf].formatoptions = (vim.bo[Args.buf].formatoptions:gsub("[ro]", ""))
            end
        end)
    end,
})

-- =============================================================================
-- Indentation: 4 spaces
-- =============================================================================
vim.opt.tabstop = 4             -- a tab character displays as 4 wide
vim.opt.shiftwidth = 4          -- >>, <<, and auto-indent use 4
vim.opt.softtabstop = 4         -- Tab / Backspace move by 4 in insert mode
vim.opt.expandtab = true        -- Tab inserts spaces, not a tab character
vim.opt.smartindent = true      -- auto-indent new lines after {
