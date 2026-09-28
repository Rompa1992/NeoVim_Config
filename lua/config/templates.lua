-- =============================================================================
-- New-file templates and file-creation commands
--
--   Any new .h / .cpp opened with :e (or created in Neo-tree) is pre-filled:
--     Engine headers  -> #pragma once + namespace Zero
--     Engine sources  -> #include "Zero/<path>.h" + namespace Zero
--     Game headers    -> #pragma once
--     Game sources    -> #include "Game/<path>.h"
--     Other sources   -> #include "<name>.h"
--
--   Commands (run from the repo root):
--     :ZENewCpp Core/Types    Engine .h + .cpp   Engine/include/Zero/Core/Types.h
--                                                Engine/src/Core/Types.cpp
--     :ZENewH   Core/Assert   Engine .h only     Engine/include/Zero/Core/Assert.h
--     :ZGNewCpp Player        Game .h + .cpp     Game/include/Game/Player.h
--                                                Game/src/Player.cpp
--     :ZGNewH   GameTypes     Game .h only       Game/include/Game/GameTypes.h
--
--   The .cpp line for CMakeLists.txt is copied to the clipboard.
-- =============================================================================

local M = {}

-- Template lines for a file path, plus the line to put the cursor on
function M.LinesFor(Path)
    local Extension = vim.fn.fnamemodify(Path, ":e")
    local bIsEngine = Path:find("/Engine/", 1, true) ~= nil

    if Extension == "h" or Extension == "hpp" then
        if bIsEngine then
            return { "#pragma once", "", "namespace Zero", "{", "", "", "", "} // namespace Zero" }, 6
        end
        return { "#pragma once", "", "" }, 3
    end

    if Extension == "cpp" then
        local EngineRelative = Path:match("/Engine/src/(.+)%.cpp$")
        if EngineRelative then
            return {
                '#include "Zero/' .. EngineRelative .. '.h"',
                "",
                "namespace Zero",
                "{",
                "",
                "",
                "",
                "} // namespace Zero",
            }, 6
        end

        local GameRelative = Path:match("/Game/src/(.+)%.cpp$")
        if GameRelative then
            return { '#include "Game/' .. GameRelative .. '.h"', "", "" }, 3
        end

        local Name = vim.fn.fnamemodify(Path, ":t:r")
        return { '#include "' .. Name .. '.h"', "", "" }, 3
    end

    return nil, nil
end

-- -----------------------------------------------------------------------------
-- Fill brand-new buffers with a template
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("BufNewFile", {
    group = vim.api.nvim_create_augroup("ZeroTemplates", { clear = true }),
    pattern = { "*.h", "*.hpp", "*.cpp" },
    callback = function(Args)
        local Path = vim.fs.normalize(vim.api.nvim_buf_get_name(Args.buf))
        local Lines, CursorLine = M.LinesFor(Path)
        if not Lines then
            return
        end

        vim.api.nvim_buf_set_lines(Args.buf, 0, -1, false, Lines)
        vim.api.nvim_win_set_cursor(0, { CursorLine, 0 })
    end,
})

-- -----------------------------------------------------------------------------
-- Helpers
-- -----------------------------------------------------------------------------
local function RepoRoot()
    local Root = vim.fs.normalize(vim.fn.getcwd())
    if vim.fn.isdirectory(Root .. "/Engine") == 0 or vim.fn.isdirectory(Root .. "/Game") == 0 then
        vim.notify("Run this from the ZeroEngine repo root (Engine/ and Game/ must be here)", vim.log.levels.ERROR)
        return nil
    end
    return Root
end

-- Turns "Core\Types.h" / "Core/Types.cpp" / "Core/Types" into "Core/Types"
local function CleanName(Raw)
    local Name = Raw:gsub("\\", "/")
    Name = Name:gsub("%.hpp$", "")
    Name = Name:gsub("%.h$", "")
    Name = Name:gsub("%.cpp$", "")
    return Name
end

-- Writes a templated file to disk. Returns true if it was created.
local function CreateFile(Path)
    if (vim.uv or vim.loop).fs_stat(Path) then
        vim.notify("Already exists, left unchanged: " .. Path, vim.log.levels.WARN)
        return false
    end

    vim.fn.mkdir(vim.fn.fnamemodify(Path, ":h"), "p")
    local Lines = M.LinesFor(Path)
    vim.fn.writefile(Lines, Path)
    return true
end

-- Creates the files, reports them, copies the CMake line, opens them
--   Header:      full path of the .h
--   Source:      full path of the .cpp, or nil for header-only
--   CMakeFile:   which CMakeLists.txt the .cpp belongs in
--   CMakeEntry:  the line to add there
local function CreateAndOpen(Header, Source, CMakeFile, CMakeEntry)
    local Created = {}

    if CreateFile(Header) then
        table.insert(Created, Header)
    end

    if Source and CreateFile(Source) then
        table.insert(Created, Source)
    end

    if #Created > 0 then
        local Message = "Created:\n  " .. table.concat(Created, "\n  ")

        if Source then
            vim.fn.setreg("+", CMakeEntry)
            Message = Message .. "\n\nAdd to " .. CMakeFile .. " (copied to clipboard):\n" .. CMakeEntry
        end

        vim.notify(Message, vim.log.levels.INFO)
    end

    -- Header in this window, .cpp beside it
    vim.cmd.edit(vim.fn.fnameescape(Header))
    if Source then
        vim.cmd.vsplit(vim.fn.fnameescape(Source))
    end
end

-- -----------------------------------------------------------------------------
-- Commands
-- -----------------------------------------------------------------------------

-- Engine: .h in Engine/include/Zero/, .cpp in Engine/src/
vim.api.nvim_create_user_command("ZENewCpp", function(Opts)
    local Root = RepoRoot()
    if not Root then
        return
    end

    local Name = CleanName(Opts.args)
    CreateAndOpen(
        Root .. "/Engine/include/Zero/" .. Name .. ".h",
        Root .. "/Engine/src/" .. Name .. ".cpp",
        "Engine/CMakeLists.txt",
        "    src/" .. Name .. ".cpp"
    )
end, { nargs = 1, desc = "Engine .h + .cpp, e.g. :ZENewCpp Core/Types" })

vim.api.nvim_create_user_command("ZENewH", function(Opts)
    local Root = RepoRoot()
    if not Root then
        return
    end

    local Name = CleanName(Opts.args)
    CreateAndOpen(Root .. "/Engine/include/Zero/" .. Name .. ".h", nil, nil, nil)
end, { nargs = 1, desc = "Engine header only, e.g. :ZENewH Core/Assert" })

-- Game: .h in Game/include/Game/, .cpp in Game/src/
vim.api.nvim_create_user_command("ZGNewCpp", function(Opts)
    local Root = RepoRoot()
    if not Root then
        return
    end

    local Name = CleanName(Opts.args)
    CreateAndOpen(
        Root .. "/Game/include/Game/" .. Name .. ".h",
        Root .. "/Game/src/" .. Name .. ".cpp",
        "Game/CMakeLists.txt",
        "    src/" .. Name .. ".cpp"
    )
end, { nargs = 1, desc = "Game .h + .cpp, e.g. :ZGNewCpp Player" })

vim.api.nvim_create_user_command("ZGNewH", function(Opts)
    local Root = RepoRoot()
    if not Root then
        return
    end

    local Name = CleanName(Opts.args)
    CreateAndOpen(Root .. "/Game/include/Game/" .. Name .. ".h", nil, nil, nil)
end, { nargs = 1, desc = "Game header only, e.g. :ZGNewH GameTypes" })

return M
