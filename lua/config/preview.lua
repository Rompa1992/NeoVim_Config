-- =============================================================================
-- Preview files
--
-- A file opened by the debugger stepping into it, or by jumping to a build error
-- from the quickfix list or Trouble, is a preview: it shows in its window, but gets
-- no tab. Typing in it, saving it, or pinning it with Space p makes it a normal file.
--
-- When debugging stops, previews the debugger opened are closed (dap.lua calls
-- CloseDebugPreviews). Previews from build errors stay open, just without a tab.
--
-- bufferline.lua hides previews with IsPreview.
-- =============================================================================

local M = {}

-- vim.b.ZeroPreview is "debug" or "error" while a file is a preview, nil once it's kept

function M.IsPreview(Buffer)
    return vim.api.nvim_buf_is_valid(Buffer) and vim.b[Buffer].ZeroPreview ~= nil
end

-- Makes a preview a normal file with a tab
function M.Keep(Buffer)
    if Buffer == 0 then
        Buffer = vim.api.nvim_get_current_buf()
    end
    if M.IsPreview(Buffer) then
        vim.b[Buffer].ZeroPreview = nil
        vim.cmd.redrawtabline()
    end
end

-- Closes every file the debugger opened that you didn't edit
function M.CloseDebugPreviews()
    for _, Buffer in ipairs(vim.api.nvim_list_bufs()) do
        if M.IsPreview(Buffer) and vim.b[Buffer].ZeroPreview == "debug" and not vim.bo[Buffer].modified then
            require("mini.bufremove").delete(Buffer, false)
        end
    end
end

-- True if the debugger's stopped arrow is in Buffer: it opened the file to show where it stopped
local function HasDebuggerArrow(Buffer)
    for _, Placed in ipairs(vim.fn.sign_getplaced(Buffer, { group = "*" })) do
        for _, Sign in ipairs(Placed.signs) do
            if Sign.name == "DapStopped" then
                return true
            end
        end
    end
    return false
end

-- True if the window we just came from is the quickfix list or Trouble
local function CameFromErrorList()
    local PreviousWindow = vim.fn.win_getid(vim.fn.winnr("#"))
    if PreviousWindow == 0 or not vim.api.nvim_win_is_valid(PreviousWindow) then
        return false
    end
    local PreviousBuffer = vim.api.nvim_win_get_buf(PreviousWindow)
    return vim.bo[PreviousBuffer].buftype == "quickfix" or vim.bo[PreviousBuffer].filetype == "trouble"
end

local Group = vim.api.nvim_create_augroup("ZeroPreview", { clear = true })

-- A file read from disk for the first time decides here whether it's a preview.
-- The debugger places its arrow just after reading the file, so that check waits a moment.
vim.api.nvim_create_autocmd("BufReadPost", {
    group = Group,
    callback = function(Args)
        local bFromErrorList = CameFromErrorList()
        vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(Args.buf) then
                return
            end
            local Kind = (bFromErrorList and "error") or (HasDebuggerArrow(Args.buf) and "debug") or nil
            if Kind then
                vim.b[Args.buf].ZeroPreview = Kind
                vim.cmd.redrawtabline()
            end
        end)
    end,
})

-- Typing in a preview, or saving it, keeps it
vim.api.nvim_create_autocmd("BufModifiedSet", {
    group = Group,
    callback = function(Args)
        if vim.bo[Args.buf].modified then
            M.Keep(Args.buf)
        end
    end,
})
vim.api.nvim_create_autocmd("BufWritePost", {
    group = Group,
    callback = function(Args)
        M.Keep(Args.buf)
    end,
})

return M
