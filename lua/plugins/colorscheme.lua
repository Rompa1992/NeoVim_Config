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
                    dark0_soft = c.gruvbox.dark0_soft,

                    -- UI / borders
                    dark1 = c.surface1,
                    dark2 = c.surface2,
                    dark3 = c.gruvbox.dark3,

                    -- Foreground
                    light0_hard = c.gruvbox.light0_hard,
                    light0      = c.fg,
                    light0_soft = c.fg_soft,

                    light1 = c.beige,
                    light2 = c.gruvbox.light2,
                    light3 = c.gray,

                    -- Gruvbox accents, kept muted
                    bright_red    = c.gruvbox.bright_red,
                    bright_green  = c.gruvbox.bright_green,
                    bright_yellow = c.gruvbox.bright_yellow,
                    bright_blue   = c.gruvbox.bright_blue,
                    bright_purple = c.gruvbox.bright_purple,
                    bright_aqua   = c.gruvbox.bright_aqua,
                    bright_orange = c.gruvbox.bright_orange,
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

                    -- Built-in types (float, bool, char): the same pink as every other type
                    ["@type.builtin"] = { fg = c.type_pink or c.prussian },

                    -- void / return (void comes from after/queries/cpp/highlights.scm)
                    ["@type.void"]      = { fg = c.red, bold = true },
                    ["@keyword.return"] = { fg = c.red, bold = true },

                    -- Your own types and members before clangd attaches
                    ["@type"]            = { fg = c.type_pink or c.prussian },
                    ["@property"]        = { fg = c.prussian_light },
                    ["@variable.member"] = { fg = c.prussian_light },
                    ["@module"]          = { fg = c.beige, italic = true },

                    -- =========================================================
                    -- Keyword structure
                    -- =========================================================

                    -- Plain keywords (template, namespace, using, typename): quiet, so red means control flow only
                    ["@keyword"] = { fg = c.beige },

                    -- Control flow (if, else, switch, for, while): red, like return
                    ["@keyword.conditional"] = { fg = c.red },
                    ["@keyword.repeat"]      = { fg = c.red },

                    -- Modifiers (constexpr, inline, extern): soft text colour, not italic, so they never look like comments
                    ["@keyword.modifier"] = { fg = c.fg_soft },

                    -- const: the palette's qualifier colour (from after/queries/cpp/highlights.scm)
                    ["@keyword.const"] = { fg = c.qualifier, italic = true },

                    -- static: the same red as delete (from after/queries/cpp/highlights.scm)
                    ["@keyword.static"] = { link = "@keyword.operator" },

                    -- public, private, protected: the #include orange (from after/queries/cpp/highlights.scm)
                    ["@keyword.access"] = { fg = c.directive_orange },

                    -- constexpr, inline: the quiet modifier colour (from after/queries/cpp/highlights.scm)
                    ["@keyword.constexpr"] = { link = "@keyword.modifier" },
                    ["@keyword.inline"]    = { link = "@keyword.modifier" },

                    -- static_assert: the macro purple, like check and checkf, without the bold
                    ["@keyword.static_assert"] = { fg = c.macro_purple },

                    -- Type keywords (struct, enum, class): Prussian italic
                    ["@keyword.type"] = { fg = c.prussian, italic = true },

                    -- =========================================================
                    -- Quiet punctuation (brackets keep their colour)
                    -- =========================================================

                    ["@punctuation.delimiter"] = { fg = c.gray },     -- ; , . ::
                    ["@operator"]              = { fg = c.operator or c.fg_soft },  -- = + - * < > && & !

                    -- =========================================================
                    -- Markdown (render-markdown.lua): headings step down from amber, CRT-style
                    -- =========================================================

                    ["@markup.heading.1.markdown"] = { fg = c.string_yellow, bold = true },
                    ["@markup.heading.2.markdown"] = { fg = c.directive_orange, bold = true },
                    ["@markup.heading.3.markdown"] = { fg = c.green, bold = true },
                    ["@markup.heading.4.markdown"] = { fg = c.prussian_light, bold = true },
                    ["@markup.heading.5.markdown"] = { fg = c.muted_pink },
                    ["@markup.heading.6.markdown"] = { fg = c.beige },

                    RenderMarkdownH1 = { fg = c.string_yellow, bold = true },
                    RenderMarkdownH2 = { fg = c.directive_orange, bold = true },
                    RenderMarkdownH3 = { fg = c.green, bold = true },
                    RenderMarkdownH4 = { fg = c.prussian_light, bold = true },
                    RenderMarkdownH5 = { fg = c.muted_pink },
                    RenderMarkdownH6 = { fg = c.beige },

                    -- Heading bands: the faintest tint of each heading colour
                    RenderMarkdownH1Bg = { bg = "#29231a" },
                    RenderMarkdownH2Bg = { bg = "#291e17" },
                    RenderMarkdownH3Bg = { bg = "#1f2218" },
                    RenderMarkdownH4Bg = { bg = "#1d2022" },
                    RenderMarkdownH5Bg = { bg = "#241d20" },
                    RenderMarkdownH6Bg = { bg = c.band },

                    -- Code: blocks on the popup background, inline code in brass
                    RenderMarkdownCode           = { bg = c.guide },
                    RenderMarkdownCodeInline     = { fg = c.template or c.orange, bg = c.band },
                    ["@markup.raw.markdown_inline"] = { fg = c.template or c.orange },

                    -- Text
                    ["@markup.strong"]     = { fg = c.fg, bold = true },
                    ["@markup.italic"]     = { fg = c.fg_soft, italic = true },
                    ["@markup.link.label"] = { fg = c.prussian_light, underline = true },
                    ["@markup.link.url"]   = { fg = c.gray, underline = true },
                    ["@markup.quote"]      = { fg = c.fg_soft, italic = true },
                    RenderMarkdownBullet   = { fg = c.directive_orange },
                    RenderMarkdownQuote    = { fg = c.gray },
                    RenderMarkdownDash     = { fg = c.surface2 },

                    -- Tables: amber header, quiet borders
                    RenderMarkdownTableHead = { fg = c.string_yellow },
                    RenderMarkdownTableRow  = { fg = c.gray },

                    -- Callouts: info and notes blue, tips green, questions and warnings amber, errors red
                    RenderMarkdownInfo    = { fg = c.prussian_light },
                    RenderMarkdownSuccess = { fg = c.green },
                    RenderMarkdownHint    = { fg = c.macro_purple },
                    RenderMarkdownWarn    = { fg = c.string_yellow },
                    RenderMarkdownError   = { fg = c.red },

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
                    ["@lsp.type.class"]  = { fg = c.type_pink or c.prussian },
                    ["@lsp.type.struct"] = { fg = c.type_pink or c.prussian },
                    ["@lsp.type.type"]   = { fg = c.type_pink or c.prussian },

                    -- clangd calls classes and structs both "class"; the LspTokenUpdate
                    -- autocommand in lsp.lua splits them by prefix: C types and F types
                    ["@lsp.zero.class"]  = { fg = c.muted_pink },
                    ["@lsp.zero.struct"] = { fg = c.prussian_strong },

                    -- T types (TArray, TFixedArray, TStaticArray, TArrayView, TUniquePtr): Prussian blue,
                    -- so the container stands apart from the pink element type inside it (lsp.lua)
                    ["@lsp.zero.template"] = { fg = c.template or c.prussian },

                    -- Members of C classes: white like locals, but bold. Struct members stay pale blue
                    ["@lsp.zero.classmember"] = { fg = c.fg, bold = true },

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

                    -- Standard library functions: green like the rest, so nothing changes colour while clangd restarts
                    ["@lsp.typemod.function.defaultLibrary"] = { fg = c.green },
                    ["@lsp.typemod.method.defaultLibrary"]   = { fg = c.green },

                    -- Namespaces
                    ["@lsp.type.namespace"] = { fg = c.beige, italic = true },
                },
            })

            vim.cmd("colorscheme gruvbox")
        end,
    },
}
