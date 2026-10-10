-- =============================================================================
-- Sumi and Washi
-- Old rustic Japanese: ink-black backgrounds, washi-paper text, and muted
-- traditional dyes. Every code colour reads at 3.8:1 or better on the background.
-- =============================================================================

return {
    -- Backgrounds: sumi ink
    bg_hard  = "#131210",
    bg       = "#1a1916",
    bg_dim   = "#161513",  -- inactive (unfocused) windows
    surface1 = "#2d2a25",  -- status bar background
    surface2 = "#423d35",  -- status bar middle section

    -- Main text: washi paper
    fg      = "#cbbd9c",
    fg_soft = "#aea38a",
    beige   = "#968b75",   -- rikyu-nezumi: modifiers
    gray    = "#7d7466",   -- nezumi: comments, punctuation

    -- Basic syntax
    red    = "#c25b45",    -- shu: vermilion, control flow and return
    green  = "#94a061",    -- uguisu: functions
    pink   = "#b8868f",    -- momo: numbers, built-in types
    orange = "#b39257",    -- kincha: golden brown

    -- Strings (also the amber accent in the UI): yamabuki
    string_yellow = "#d6ad62",

    -- Classes / structs: ai indigo and asagi
    prussian        = "#6d8ba0",
    prussian_light  = "#8597a0",
    prussian_strong = "#5e98a0",  -- structs (F types): asagi, blue-green

    -- Enums: koke moss
    enum_green  = "#7f8c55",
    muted_green = "#97a070",

    -- Namespaces and C classes: sakura-nezumi
    muted_pink = "#a88395",

    -- Globals: sabi
    dusty_red = "#b06a58",

    -- Preprocessor
    macro_purple     = "#9a78b8",  -- fuji: wisteria, macros and static_assert
    directive_orange = "#c27840",  -- kaki: persimmon, #include, #define, #if, #pragma

    -- Qualifiers
    rust      = "#a7654a",  -- kept for anything else that used it
    qualifier = "#968b75",  -- const, constexpr, inline: quiet, like the other modifiers

    -- Mode colours (line number + status bar)
    mode_normal  = "#d6ad62",  -- yamabuki
    mode_insert  = "#94a061",  -- uguisu
    mode_visual  = "#b8694a",  -- persimmon rust
    mode_replace = "#c25b45",  -- shu
    mode_command = "#8597a0",  -- light ai

    -- UI surfaces
    line_number = "#4b463d",  -- inactive line numbers
    band        = "#211f1b",  -- current line band
    guide       = "#1f1d19",  -- 120-column guide, popup background
    selection   = "#3b3226",  -- visual selection
    hint        = "#645e52",  -- inlay hints
    yank        = "#4d3e24",  -- flash when text is copied

    -- Gruvbox base colours this palette overrides
    gruvbox = {
        dark0_soft    = "#24221e",
        dark3         = "#5c564b",
        light0_hard   = "#ddd0b0",
        light2        = "#857c6c",
        bright_red    = "#c25b45",
        bright_green  = "#94a061",
        bright_yellow = "#c4a35e",
        bright_blue   = "#6d8ba0",
        bright_purple = "#a88395",
        bright_aqua   = "#5e98a0",
        bright_orange = "#c27840",
    },
}
