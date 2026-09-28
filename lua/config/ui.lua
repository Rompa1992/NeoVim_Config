-- =============================================================================
-- UI behaviour
--   * Flash on yank:           copied text briefly glows amber
--   * Mode-coloured line number: amber (normal), olive (insert), rust (visual)...
--   * Diagnostics:             full message on its own line under the cursor line
-- =============================================================================

local c = require("config.palette")

-- -----------------------------------------------------------------------------
-- Flash on yank
-- -----------------------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
    group = vim.api.nvim_create_augroup("ZeroYankFlash", { clear = true }),
    callback = function()
        local hl = vim.hl or vim.highlight
        hl.on_yank({ higroup = "ZeroYank", timeout = 180 })
    end,
})

-- -----------------------------------------------------------------------------
-- Mode-coloured current line number
-- -----------------------------------------------------------------------------
local ModeColours = {
    n = c.mode_normal,
    i = c.mode_insert,
    v = c.mode_visual,
    V = c.mode_visual,
    ["\22"] = c.mode_visual,  -- Ctrl+V block visual
    R = c.mode_replace,
    c = c.mode_command,
}

local function UpdateLineNumberColour()
    local Mode = vim.api.nvim_get_mode().mode:sub(1, 1)
    local Colour = ModeColours[Mode] or c.mode_normal
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = Colour, bold = true })
end

local ModeGroup = vim.api.nvim_create_augroup("ZeroModeLineNumber", { clear = true })

vim.api.nvim_create_autocmd({ "ModeChanged", "ColorScheme", "VimEnter" }, {
    group = ModeGroup,
    callback = UpdateLineNumberColour,
})

-- -----------------------------------------------------------------------------
-- Diagnostics display
-- -----------------------------------------------------------------------------
vim.diagnostic.config({
    virtual_text = false,                      -- no truncated text at the end of lines
    virtual_lines = true,                      -- full message below the line the cursor is on
    severity_sort = true,                      -- errors above warnings
    underline = true,
    float = { border = "rounded" },
})

-- -----------------------------------------------------------------------------
-- Colour inspector: which highlight groups colour the word under the cursor
-- Use: Space + i, :ZeroInspect, or right-click > Inspect colour
-- -----------------------------------------------------------------------------
local function HexOf(Group)
    local Hl = vim.api.nvim_get_hl(0, { name = Group, link = false })
    if Hl.fg then
        return string.format("#%06x", Hl.fg)
    end
    return "(no colour)"
end

local function ZeroInspect()
    local Info = vim.inspect_pos()
    local Lines = { "**Colour groups under cursor** (lowest wins)", "" }

    local function AddSection(Title, Groups)
        if #Groups == 0 then
            return
        end
        table.insert(Lines, "**" .. Title .. "**")
        for _, Group in ipairs(Groups) do
            table.insert(Lines, string.format("- `%s`  %s", Group, HexOf(Group)))
        end
        table.insert(Lines, "")
    end

    local Treesitter = {}
    for _, Entry in ipairs(Info.treesitter or {}) do
        table.insert(Treesitter, Entry.hl_group)
    end

    local Semantic = {}
    for _, Entry in ipairs(Info.semantic_tokens or {}) do
        if Entry.opts and Entry.opts.hl_group then
            table.insert(Semantic, Entry.opts.hl_group)
        end
    end

    local Syntax = {}
    for _, Entry in ipairs(Info.syntax or {}) do
        table.insert(Syntax, Entry.hl_group)
    end

    AddSection("Treesitter", Treesitter)
    AddSection("clangd", Semantic)
    AddSection("Syntax", Syntax)

    if #Treesitter + #Semantic + #Syntax == 0 then
        table.insert(Lines, "No highlight groups here")
    end

    vim.lsp.util.open_floating_preview(Lines, "markdown", { border = "rounded", focus_id = "ZeroInspect" })
end

vim.api.nvim_create_user_command("ZeroInspect", ZeroInspect, { desc = "Show colour groups under the cursor" })
vim.keymap.set("n", "<leader>i", ZeroInspect, { desc = "Inspect colour under cursor" })

-- -----------------------------------------------------------------------------
-- Right-click menu: replace Neovim's default with useful C++ actions
-- -----------------------------------------------------------------------------
-- Remove the built-in autocmd that enables/disables the default menu items
pcall(vim.api.nvim_del_augroup_by_name, "nvim.popupmenu")
pcall(vim.api.nvim_del_augroup_by_name, "nvim_popupmenu")

vim.cmd([[
    silent! aunmenu PopUp
    anoremenu PopUp.Go\ to\ definition    <Cmd>lua vim.lsp.buf.definition()<CR>
    anoremenu PopUp.Go\ to\ declaration   <Cmd>lua vim.lsp.buf.declaration()<CR>
    anoremenu PopUp.Find\ references      <Cmd>lua vim.lsp.buf.references()<CR>
    anoremenu PopUp.Rename\ symbol        <Cmd>lua vim.lsp.buf.rename()<CR>
    anoremenu PopUp.Show\ info            <Cmd>lua vim.lsp.buf.hover()<CR>
    anoremenu PopUp.-Sep1-                <Nop>
    anoremenu PopUp.Switch\ \.h/\.cpp     <Cmd>LspClangdSwitchSourceHeader<CR>
    anoremenu PopUp.Inspect\ colour       <Cmd>ZeroInspect<CR>
    anoremenu PopUp.-Sep2-                <Nop>
    vnoremenu PopUp.Copy                  "+y
    vnoremenu PopUp.Cut                   "+d
    anoremenu PopUp.Paste                 "+gP
    nnoremenu PopUp.Select\ all           ggVG
]])
