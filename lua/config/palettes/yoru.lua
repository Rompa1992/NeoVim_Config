-- =============================================================================
-- Natsu Yoru: summer night
-- A warm Japanese summer night on a VHS tape: blue-black sky, lantern and
-- whiskey light, faded neon signs. Every code colour reads at 4.4:1 or better.
-- =============================================================================

return {
    -- Backgrounds: night sky, blue-black
    bg_hard  = "#121218",
    bg       = "#18181f",
    bg_dim   = "#15151b",  -- inactive (unfocused) windows
    surface1 = "#26242e",  -- status bar background
    surface2 = "#36323f",  -- status bar middle section

    -- Main text: lantern cream
    fg      = "#e8d5b0",
    fg_soft = "#c7b494",
    beige   = "#a4927a",   -- old paper: modifiers
    gray    = "#857b8c",   -- dusk lavender: comments, punctuation

    -- Basic syntax
    red    = "#e0604f",    -- lantern red: control flow and return
    green  = "#a8c27d",    -- summer leaves: functions
    pink   = "#ef8fae",    -- neon pink: numbers, built-in types
    orange = "#d9a05b",    -- whiskey

    -- Strings (also the amber accent in the UI): whiskey amber
    string_yellow = "#e6b062",

    -- Types and members
    prussian        = "#79a7d9",  -- night-sky blue: types
    prussian_light  = "#e6b2a0",  -- lantern glow: members
    prussian_strong = "#6cc0b8",  -- neon teal: structs (F types)

    -- Enums: fireflies
    enum_green  = "#b8c56b",
    muted_green = "#cfd59a",

    -- Namespaces and C classes: neon magenta
    muted_pink = "#c98bd6",

    -- Globals: ember
    dusty_red = "#e0786a",

    -- Preprocessor
    macro_purple     = "#a58ae8",  -- neon violet: macros and static_assert
    directive_orange = "#ef8f4d",  -- lantern orange: #include, #define, #if, #pragma

    -- Qualifiers
    rust      = "#c0704f",  -- kept for anything else that used it
    qualifier = "#a4927a",  -- const, constexpr, inline: quiet, like the other modifiers

    -- Mode colours (line number + status bar)
    mode_normal  = "#e6b062",  -- whiskey amber
    mode_insert  = "#a8c27d",  -- summer leaves
    mode_visual  = "#d07a5a",  -- ember
    mode_replace = "#e0604f",  -- lantern red
    mode_command = "#79a7d9",  -- night-sky blue

    -- UI surfaces
    line_number = "#4a4757",  -- inactive line numbers
    band        = "#1f1f28",  -- current line band
    guide       = "#1c1c24",  -- 120-column guide, popup background
    selection   = "#3a3448",  -- visual selection
    hint        = "#6e6880",  -- inlay hints
    yank        = "#5a4426",  -- flash when text is copied

    -- Gruvbox base colours this palette overrides
    gruvbox = {
        dark0_soft    = "#1f1f27",
        dark3         = "#55506a",
        light0_hard   = "#f3e3c0",
        light2        = "#a89b86",
        bright_red    = "#e0604f",
        bright_green  = "#a8c27d",
        bright_yellow = "#e6b062",
        bright_blue   = "#79a7d9",
        bright_purple = "#c98bd6",
        bright_aqua   = "#6cc0b8",
        bright_orange = "#ef8f4d",
    },
}
