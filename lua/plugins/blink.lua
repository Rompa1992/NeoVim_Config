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

        init = function()
            -- A snippet left unfinished stays active, and Tab later jumps back into its old fields.
            -- Leaving Insert mode ends it.
            vim.api.nvim_create_autocmd("ModeChanged", {
                group = vim.api.nvim_create_augroup("ZeroSnippetStop", { clear = true }),
                pattern = "*:n",
                callback = function()
                    if vim.snippet.active() then
                        vim.snippet.stop()
                    end
                end,
            })
        end,

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

            -- Function parameters shown while typing a call's arguments
            signature = {
                enabled = true,
            },

            appearance = {
                nerd_font_variant = "mono",
            },

            completion = {
                documentation = {
                    auto_show = true,
                },

                -- Inside a snippet with a field still to fill, nothing is preselected,
                -- so Tab jumps to the next field instead of accepting whatever the menu shows
                list = {
                    selection = {
                        preselect = function()
                            return not require("blink.cmp").snippet_active({ direction = 1 })
                        end,
                    },
                },
            },

            sources = {
                -- "snippets" reads Config/snippets/ (zstruct, zsys, zenum, zcheck...)
                default = { "lsp", "snippets", "path", "buffer" },

                providers = {
                    lsp = {
                        -- clangd only offers [[nodiscard]] as a snippet with a message slot, nodiscard($0),
                        -- so accepting it gave [[nodiscard()]]. Strip the brackets from that one item.
                        -- Replacing transform_items also replaces blink's default one, which drops plain
                        -- Text items (the buffer source covers those), so that filter is kept here.
                        transform_items = function(_, AllItems)
                            local TextKind = require("blink.cmp.types").CompletionItemKind.Text
                            local Items = vim.tbl_filter(function(Item)
                                return Item.kind ~= TextKind
                            end, AllItems)

                            for _, Item in ipairs(Items) do
                                local Text = Item.textEdit and Item.textEdit.newText or Item.insertText
                                local Name = Text and Text:match("^(_*nodiscard_*)%(%$0%)$")
                                if Name then
                                    if Item.textEdit then
                                        Item.textEdit.newText = Name
                                    end
                                    Item.insertText = Name
                                    Item.insertTextFormat = vim.lsp.protocol.InsertTextFormat.PlainText
                                end
                            end
                            return Items
                        end,
                    },
                },
            },
        },
    },
}
