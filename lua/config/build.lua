-- =============================================================================
-- Build, run and test for ZeroEngine
--
--   Space b   build Debug                 message on success, error list on failure
--   Space B   build Release
--   Space r   build Debug, then run Game        (only if the build succeeded)
--   Space t   build Debug, then run ZeroTests   (only if the build succeeded)
--
-- The run window is reused: running again replaces it instead of stacking splits.
-- Neovim must be started from the repo root.
--
-- Other files can call require("config.build").Build("debug"), which returns true/false
-- (dap.lua uses it so F5 never debugs a stale exe).
-- =============================================================================

local M = {}

local RunWindow = nil
local RunBuffer = nil

local function Notify(Message, Level)
    vim.notify(Message, Level or vim.log.levels.INFO, { title = "ZeroEngine" })
end

local function CountValidQuickfixEntries()
    local Count = 0
    for _, Entry in ipairs(vim.fn.getqflist()) do
        if Entry.valid == 1 then
            Count = Count + 1
        end
    end
    return Count
end

-- Builds a CMake preset ("debug" or "release"). Returns true if the build succeeded.
function M.Build(Preset)
    Preset = Preset or "debug"

    vim.cmd("silent! wall")

    local SavedMakeprg = vim.o.makeprg
    vim.o.makeprg = "cmake --build --preset " .. Preset
    vim.cmd("silent make!")
    vim.o.makeprg = SavedMakeprg

    -- :make stores the build command's exit code here: 0 = success
    if vim.v.shell_error ~= 0 then
        Notify("Build FAILED (" .. Preset .. ")", vim.log.levels.ERROR)
        vim.cmd("botright copen")
        return false
    end

    local WarningCount = CountValidQuickfixEntries()
    if WarningCount > 0 then
        Notify("Build succeeded (" .. Preset .. ") with " .. WarningCount .. " warning(s)", vim.log.levels.WARN)
        vim.cmd("botright copen")
    else
        Notify("Build succeeded (" .. Preset .. ")")
        vim.cmd("cclose")
    end

    return true
end

local function ExePath(Preset, Name)
    local BuildDir = (Preset == "release") and "build-release" or "build"
    local Extension = (vim.fn.has("win32") == 1) and ".exe" or ""
    local Path = BuildDir .. "/bin/" .. Name .. Extension

    if vim.fn.filereadable(Path) == 1 then
        return Path
    end
    return nil
end

local function OpenTerminal(Command)
    if vim.fn.has("nvim-0.11") == 1 then
        vim.fn.jobstart(Command, { term = true })
    else
        vim.fn.termopen(Command)
    end
end

-- Runs an exe in the bottom run window, replacing whatever ran there last.
local function RunInTerminal(Path)
    local OldBuffer = RunBuffer

    if RunWindow and vim.api.nvim_win_is_valid(RunWindow) then
        vim.api.nvim_set_current_win(RunWindow)
    else
        vim.cmd("botright 15split")
        RunWindow = vim.api.nvim_get_current_win()
    end

    RunBuffer = vim.api.nvim_create_buf(false, true) -- unlisted: never shows in the bufferline
    vim.api.nvim_win_set_buf(RunWindow, RunBuffer)
    OpenTerminal({ Path })

    if OldBuffer and vim.api.nvim_buf_is_valid(OldBuffer) then
        vim.api.nvim_buf_delete(OldBuffer, { force = true })
    end
end

-- Builds, and only if that succeeded, runs the named exe.
function M.BuildAndRun(Name, Preset)
    Preset = Preset or "debug"

    if not M.Build(Preset) then
        return
    end

    local Path = ExePath(Preset, Name)
    if not Path then
        Notify("Built, but " .. Name .. " was not found in " .. Preset .. " output (build/bin/)", vim.log.levels.ERROR)
        return
    end

    RunInTerminal(Path)
end

vim.keymap.set("n", "<leader>b", function() M.Build("debug") end, { desc = "Build (Debug)" })
vim.keymap.set("n", "<leader>B", function() M.Build("release") end, { desc = "Build (Release)" })
vim.keymap.set("n", "<leader>r", function() M.BuildAndRun("Game") end, { desc = "Build + run Game" })
vim.keymap.set("n", "<leader>t", function() M.BuildAndRun("ZeroTests") end, { desc = "Build + run ZeroTests" })

return M

