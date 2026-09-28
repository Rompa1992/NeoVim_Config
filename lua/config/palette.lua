-- =============================================================================
-- ZeroEngine palette
-- One place for every colour. Used by colorscheme.lua, lualine.lua, ui.lua,
-- alpha.lua and todo-comments.lua, so the whole editor stays consistent.
-- =============================================================================

return {
    -- Backgrounds
    bg_hard  = "#141515",
    bg       = "#1b1c1b",
    bg_dim   = "#171817",  -- inactive (unfocused) windows
    surface1 = "#302f2b",  -- status bar background
    surface2 = "#44413a",  -- status bar middle section

    -- Main text
    fg      = "#c5b99a",
    fg_soft = "#aaa18a",
    beige   = "#918875",
    gray    = "#71695c",

    -- Basic syntax
    red    = "#b85c55",
    green  = "#84945a",
    pink   = "#a87587",
    orange = "#b8794f",

    -- Strings (also the CRT amber accent in the UI)
    string_yellow = "#d4b26a",

    -- Classes / structs
    prussian       = "#4f6975",
    prussian_light = "#71828a",

    -- Enums
    enum_green  = "#687744",
    muted_green = "#7d865c",

    -- Namespaces
    muted_pink = "#927080",

    -- Globals
    dusty_red = "#a76662",

    -- Preprocessor
    macro_purple     = "#8e62b8",  -- strong purple: macros
    directive_orange = "#b8703f",  -- burnt brown-orange: #include, #define, #if, #pragma

    -- Qualifiers
    rust = "#9c5a3c",  -- rusty brown: const

    -- Mode colours (line number + status bar)
    mode_normal  = "#d4b26a",  -- amber
    mode_insert  = "#84945a",  -- olive
    mode_visual  = "#b0694a",  -- rust (lighter, readable as a background)
    mode_replace = "#b85c55",  -- red
    mode_command = "#71828a",  -- light Prussian

    -- UI surfaces
    line_number = "#4a463e",  -- inactive line numbers
    band        = "#211f1c",  -- current line band
    guide       = "#201e1b",  -- 120-column guide, popup background
    selection   = "#3a3226",  -- visual selection
    hint        = "#5f5a50",  -- inlay hints
    yank        = "#4a3d24",  -- flash when text is copied
}
