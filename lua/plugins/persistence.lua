return {
    {
        -- Persistence
        -- Saves your open files, splits and cursor positions when Neovim quits,
        -- one session per project folder, and restores them on request
        -- Use: Space + qs   restore the session for this folder
        --      Space + ql   restore the last session (any folder)
        --      Space + qd   don't save a session when quitting this time
        --      Start screen: s = restore session
        "folke/persistence.nvim",
        event = "BufReadPre",  -- starts recording once you open a file

        init = function()
            -- What a session remembers. "terminal" is left out on purpose:
            -- build/run terminal windows would come back as dead empty windows.
            vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

            -- Close Neo-tree before saving, so it doesn't come back as an empty window
            vim.api.nvim_create_autocmd("User", {
                group = vim.api.nvim_create_augroup("ZeroPersistence", { clear = true }),
                pattern = "PersistenceSavePre",
                callback = function()
                    pcall(vim.cmd, "Neotree close")
                end,
            })
        end,

        opts = {},

        keys = {
            { "<leader>qs", function() require("persistence").load() end, desc = "Restore session (this folder)" },
            { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
            { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save session on quit" },
        },
    },
}
