return {
    {
        -- Fidget
        -- Small progress indicator in the bottom-right corner:
        -- shows when clangd is indexing / loading, so you know it's working
        "j-hui/fidget.nvim",
        event = "LspAttach",

        opts = {
            progress = {
                display = {
                    done_icon = "✓",   -- shown briefly when a task finishes
                    done_ttl = 2,      -- seconds to keep finished tasks visible
                },
            },

            notification = {
                window = {
                    winblend = 0,       -- solid background (no transparency)
                    border = "none",
                },
            },
        },
    },
}
