-- =============================================================================
-- Sakura
-- Old Japanese, warmer and pinker: neutral ink backgrounds, silk-white text,
-- cherry-pink members, and traditional dye colours for everything else.
-- Every code colour reads at 4.4:1 or better on the background.
-- =============================================================================

return {
    -- Backgrounds: neutral ink, no tint
    bg_hard  = "#141414",
    bg       = "#1b1b1b",
    bg_dim   = "#171717",  -- inactive (unfocused) windows
    surface1 = "#2b2b2b",  -- status bar background
    surface2 = "#3e3e3e",  -- status bar middle section

    -- Main text: shironeri, silk white
    fg      = "#ddd1cc",
    fg_soft = "#c4b2b0",
    beige   = "#ae97a0",   -- mauve: modifiers
    gray    = "#8b7a82",   -- plum grey: comments, punctuation

    -- Basic syntax
    red    = "#d4646f",    -- beni: control flow and return
    green  = "#a6b47a",    -- wakatake, young bamboo: functions
    pink   = "#e3a882",    -- anzu, apricot: numbers, built-in types
    orange = "#cfa36a",    -- kincha: golden brown

    -- Strings (also the amber accent in the UI): yamabuki
    string_yellow = "#e0b770",

    -- Types and members
    prussian        = "#8ea3c8",  -- wasurenagusa, forget-me-not: types
    prussian_light  = "#ddb0bc",  -- sakura: members
    prussian_strong = "#72b3b4",  -- asagi: structs (F types)

    -- Enums: moss and willow
    enum_green  = "#9aa96b",
    muted_green = "#b6bf8c",

    -- Namespaces and C classes: botan, peony
    muted_pink = "#c98aa8",

    -- Globals: coral
    dusty_red = "#d97f78",

    -- Preprocessor
    macro_purple     = "#b08ad6",  -- fuji: wisteria, macros and static_assert
    directive_orange = "#d88b5c",  -- kaki: persimmon, #include, #define, #if, #pragma

    -- Qualifiers
    rust      = "#b86a58",  -- kept for anything else that used it
    qualifier = "#ae97a0",  -- const, constexpr, inline: quiet, like the other modifiers

    -- Mode colours (line number + status bar)
    mode_normal  = "#e3a3b5",  -- sakura
    mode_insert  = "#a6b47a",  -- wakatake
    mode_visual  = "#c9788f",  -- deeper cherry
    mode_replace = "#d4646f",  -- beni
    mode_command = "#8ea3c8",  -- forget-me-not

    -- UI surfaces
    line_number = "#4c4c4c",  -- inactive line numbers
    band        = "#222222",  -- current line band
    guide       = "#1f1f1f",  -- 120-column guide, popup background
    selection   = "#3a3a3a",  -- visual selection
    hint        = "#6e6a6c",  -- inlay hints
    yank        = "#5b3a47",  -- flash when text is copied

    -- Gruvbox base colours this palette overrides
    gruvbox = {
        dark0_soft    = "#232323",
        dark3         = "#5a5a5a",
        light0_hard   = "#efe5e1",
        light2        = "#9b898f",
        bright_red    = "#d4646f",
        bright_green  = "#a6b47a",
        bright_yellow = "#d9b06c",
        bright_blue   = "#8ea3c8",
        bright_purple = "#c98aa8",
        bright_aqua   = "#72b3b4",
        bright_orange = "#d88b5c",
    },
}
