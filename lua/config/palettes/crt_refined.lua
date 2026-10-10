-- =============================================================================
-- Gruvbox CRT, refined: the original, with dark colours lifted so they read.
-- Same background, same feel.
-- One place for every colour. Used by colorscheme.lua, lualine.lua, ui.lua,
-- alpha.lua and todo-comments.lua, so the whole editor stays consistent.
-- =============================================================================

return {
    -- Backgrounds
    bg_hard  = "#141312",
    bg       = "#1b1917",
    bg_dim   = "#151412",  -- inactive (unfocused) windows
    surface1 = "#302f2b",  -- status bar background
    surface2 = "#44413a",  -- status bar middle section

    -- Main text
    fg      = "#c5b99a",
    fg_soft = "#aaa18a",
    beige   = "#918875",
    gray    = "#7a7264",

    -- Basic syntax
    red    = "#b85c55",
    green  = "#84945a",
    pink   = "#a87587",
    orange = "#b39257",

    -- Strings (also the CRT amber accent in the UI)
    string_yellow = "#d4b26a",

    -- Classes / structs
    prussian       = "#5f7d8a",
    prussian_light = "#858d8f",
    prussian_strong = "#426e84",  -- structs (F types): darker, more saturated Prussian
    template        = "#5f7d8a",  -- T types: Prussian blue
    type_pink       = "#c28d9c",  -- types: int32, float, aliases. Lighter than the number pink
    operator        = "#e0904f",  -- = < ! &&: bright orange

    -- Enums
    enum_green  = "#637241",
    muted_green = "#6b7a47",

    -- Namespaces
    muted_pink = "#927080",

    -- Globals
    dusty_red = "#a76662",

    -- Preprocessor
    macro_purple     = "#9874b8",  -- strong purple: macros
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
    band        = "#25221f",  -- current line band
    guide       = "#211f1c",  -- 120-column guide, popup background
    selection   = "#443a2b",  -- visual selection
    hint        = "#5f5a50",  -- inlay hints
    yank        = "#4a3d24",  -- flash when text is copied

    -- Qualifiers: const. constexpr and inline use the modifier beige
    qualifier = "#9c5a3c",

    -- Gruvbox base colours this palette overrides
    gruvbox = {
        dark0_soft    = "#1b1917",  -- the editor background: contrast = "soft" uses this, not bg
        dark3         = "#5b554b",
        light0_hard   = "#d8cdb0",
        light2        = "#81796b",
        bright_red    = "#c4675f",
        bright_green  = "#929f60",
        bright_yellow = "#bca05e",
        bright_blue   = "#657f87",
        bright_purple = "#a8788b",
        bright_aqua   = "#718b78",
        bright_orange = "#c08050",
    },
}
