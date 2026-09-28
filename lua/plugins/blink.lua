return {
    {
        -- Blink.cmp
        -- Autocomplete for C++ and other languages, plus our own snippets (Config/snippets/)
        -- Use: Tab accept (and jump to next snippet field)
        --      Shift+Tab next suggestion
        --      Shift+Up / Shift+Down move through suggestions
        --      Plain arrow keys move the cursor, not the menu
        "saghen/blink.cmp",
        version = "1.*",

        opts = {
            keymap = {
                preset = "super-tab",

                -- Next suggestion when the menu is open, normal Shift+Tab otherwise
                ["<S-Tab>"] = { "select_next", "fallback" },

                -- Plain arrow keys ignore the menu and move the cursor as normal
                ["<Up>"] = { "fallback" },
                ["<Down>"] = { "fallback" },

                -- Shift + arrows move through the menu when it is open
                ["<S-Up>"] = { "select_prev", "fallback" },
                ["<S-Down>"] = { "select_next", "fallback" },
            },

            appearance = {
                nerd_font_variant = "mono",
            },

            completion = {
                documentation = {
                    auto_show = true,
                },
            },

            sources = {
                -- "snippets" reads Config/snippets/ (zstruct, zsys, zenum, zcheck...)
                default = { "lsp", "snippets", "path", "buffer" },
            },
        },
    },
}
