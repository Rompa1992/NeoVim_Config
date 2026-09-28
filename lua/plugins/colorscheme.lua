return {
    {
        -- Gruvbox
        -- Dark muted retro/CRT colour scheme with C++ semantic colours
        -- Colours live in lua/config/palette.lua (shared with lualine, ui, dashboard, todo-comments)
        -- Use: :colorscheme gruvbox
        --      Space + i (or right-click > Inspect colour) shows the colour groups under the cursor
        "ellisonleao/gruvbox.nvim",
        priority = 1000,

        config = function()
            local c = require("config.palette")

            require("gruvbox").setup({
                contrast = "soft",

                palette_overrides = {
                    -- Dark background
                    dark0_hard = c.bg_hard,
                    dark0      = c.bg,
                    dark0_soft = "#252523",

                    -- UI / borders
                    dark1 = c.surface1,
                    dark2 = c.surface2,
                    dark3 = "#5b554b",

                    -- Foreground
                    light0_hard = "#d8cdb0",
                    light0      = c.fg,
                    light0_soft = c.fg_soft,

                    light1 = c.beige,
                    light2 = "#81796b",
                    light3 = c.gray,

                    -- Gruvbox accents, kept muted
                    bright_red    = "#c4675f",
                    bright_green  = "#929f60",
                    bright_yellow = "#bca05e",
                    bright_blue   = "#657f87",
                    bright_purple = "#a8788b",
                    bright_aqua   = "#718b78",
                    bright_orange = "#c08050",
                },

                overrides = {
                    -- =========================================================
                    -- UI: CRT amber accents
                    -- =========================================================

                    -- Current line number (ui.lua recolours it per mode)
                    CursorLineNr = { fg = c.mode_normal, bold = true },
                    LineNr       = { fg = c.line_number },
                    CursorLine   = { bg = c.band },
                    Visual       = { bg = c.selection },
                    MatchParen   = { fg = c.string_yellow, bold = true, underline = true },
                    ColorColumn  = { bg = c.guide },

                    -- Inactive (unfocused) windows are slightly darker
                    NormalNC     = { bg = c.bg_dim },
                    WinSeparator = { fg = c.surface2 },

                    -- Popups (hover K, diagnostics, completion docs)
                    NormalFloat = { bg = c.guide },
                    FloatBorder = { fg = c.gray, bg = c.guide },

                    -- clangd inlay hints (parameter names, deduced types)
                    LspInlayHint = { fg = c.hint, italic = true },

                    -- Flash on yank (ui.lua)
                    ZeroYank = { bg = c.yank },

                    -- Start screen (alpha.lua)
                    ZeroLogo       = { fg = c.string_yellow, bold = true },
                    ZeroDashButton = { fg = c.fg },
                    ZeroDashKey    = { fg = c.directive_orange, bold = true },
                    ZeroDashFooter = { fg = c.gray, italic = true },

                    -- =========================================================
                    -- Basics / Treesitter
                    -- =========================================================

                    Comment = { fg = c.gray, italic = true },

                    -- Strings
                    String             = { fg = c.string_yellow },
                    ["@string"]        = { fg = c.string_yellow },
                    ["@string.escape"] = { fg = c.red },

                    -- Numbers
                    Number            = { fg = c.pink },
                    Float             = { fg = c.pink },
                    ["@number"]       = { fg = c.pink },
                    ["@number.float"] = { fg = c.pink },

                    -- Built-in types
                    ["@type.builtin"] = { fg = c.pink },

                    -- void / return (void comes from after/queries/cpp/highlights.scm)
                    ["@type.void"]      = { fg = c.red, bold = true },
                    ["@keyword.return"] = { fg = c.red, bold = true },

                    -- Your own types and members before clangd attaches
                    ["@type"]            = { fg = c.prussian },
                    ["@property"]        = { fg = c.prussian_light },
                    ["@variable.member"] = { fg = c.prussian_light },
                    ["@module"]          = { fg = c.muted_pink, italic = true },

                    -- =========================================================
                    -- Keyword structure
                    -- =========================================================

                    -- Control flow (if, else, switch, for, while): red, like return
                    ["@keyword.conditional"] = { fg = c.red },
                    ["@keyword.repeat"]      = { fg = c.red },

                    -- Modifiers (static, constexpr, inline, extern): quiet italic
                    ["@keyword.modifier"] = { fg = c.beige, italic = true },

                    -- const: rusty brown (from after/queries/cpp/highlights.scm)
                    ["@keyword.const"] = { fg = c.rust, italic = true },

                    -- Type keywords (struct, enum, class): Prussian italic
                    ["@keyword.type"] = { fg = c.prussian, italic = true },

                    -- =========================================================
                    -- Quiet punctuation (brackets keep their colour)
                    -- =========================================================

                    ["@punctuation.delimiter"] = { fg = c.gray },     -- ; , . ::
                    ["@operator"]              = { fg = c.fg_soft },  -- = + - * < > && &

                    -- =========================================================
                    -- Rainbow brackets (rainbow-delimiters.lua): muted, by depth
                    -- =========================================================

                    RainbowDelimiterOrange = { fg = c.orange },
                    RainbowDelimiterBlue   = { fg = c.prussian_light },
                    RainbowDelimiterGreen  = { fg = c.muted_green },
                    RainbowDelimiterRed    = { fg = c.dusty_red },
                    RainbowDelimiterViolet = { fg = c.muted_pink },
                    RainbowDelimiterCyan   = { fg = c.beige },

                    -- =========================================================
                    -- Preprocessor
                    -- =========================================================

                    -- Macros (CHECK, ZERO_VERSION_MAJOR, SDL_VERSIONNUM_MAJOR): strong purple
                    ["@lsp.type.macro"] = { fg = c.macro_purple, bold = true },
                    ["@constant.macro"] = { fg = c.macro_purple, bold = true },
                    ["@function.macro"] = { fg = c.macro_purple, bold = true },
                    Macro               = { fg = c.macro_purple, bold = true },

                    -- Directives (#include, #define, #if, #pragma, #error): burnt orange
                    ["@keyword.import"]           = { fg = c.directive_orange },
                    ["@keyword.directive"]        = { fg = c.directive_orange },
                    ["@keyword.directive.define"] = { fg = c.directive_orange },
                    PreProc                       = { fg = c.directive_orange },
                    Include                       = { fg = c.directive_orange },
                    Define                        = { fg = c.directive_orange },

                    -- =========================================================
                    -- clangd semantic tokens
                    -- =========================================================

                    -- Classes / structs
                    ["@lsp.type.class"]  = { fg = c.prussian },
                    ["@lsp.type.struct"] = { fg = c.prussian },
                    ["@lsp.type.type"]   = { fg = c.prussian },

                    -- Struct / class members
                    ["@lsp.type.property"] = { fg = c.prussian_light },

                    -- Enums
                    ["@lsp.type.enum"]       = { fg = c.enum_green },
                    ["@lsp.type.enumMember"] = { fg = c.muted_green },

                    -- Local variables
                    ["@lsp.type.variable"]                  = { fg = c.fg },
                    ["@lsp.typemod.variable.functionScope"] = { fg = c.fg, underline = true },

                    -- Globals / file statics
                    ["@lsp.typemod.variable.globalScope"] = { fg = c.dusty_red, italic = true },
                    ["@lsp.typemod.variable.fileScope"]   = { fg = c.dusty_red, italic = true },

                    -- Parameters
                    ["@lsp.type.parameter"] = { fg = c.fg_soft, italic = true },

                    -- Functions / methods: bold where declared
                    ["@lsp.type.function"]                = { fg = c.green },
                    ["@lsp.type.method"]                  = { fg = c.green },
                    ["@lsp.typemod.function.declaration"] = { fg = c.green, bold = true },
                    ["@lsp.typemod.function.definition"]  = { fg = c.green },
                    ["@lsp.typemod.method.declaration"]   = { fg = c.green, bold = true },
                    ["@lsp.typemod.method.definition"]    = { fg = c.green },

                    -- Standard library functions
                    ["@lsp.typemod.function.defaultLibrary"] = { fg = c.beige },
                    ["@lsp.typemod.method.defaultLibrary"]   = { fg = c.beige },

                    -- Namespaces
                    ["@lsp.type.namespace"] = { fg = c.muted_pink, italic = true },

                    -- const / readonly variables: bold on top of their colour
                    ["@lsp.mod.readonly"] = { bold = true },
                },
            })

            vim.cmd("colorscheme gruvbox")
        end,
    },
}
