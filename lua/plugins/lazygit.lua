return {
    {
        -- LazyGit
        -- Full git interface in a floating window
        -- Needs the lazygit program:  winget install JesseDuffield.lazygit
        -- Use: Space + gg   open LazyGit (q to close, ? for its key help)
        "kdheepak/lazygit.nvim",
        cmd = { "LazyGit", "LazyGitCurrentFile", "LazyGitLog" },

        dependencies = {
            "nvim-lua/plenary.nvim",
        },

        keys = {
            { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" },
            { "<leader>gl", "<cmd>LazyGitLog<CR>", desc = "Git log (LazyGit)" },
        },

        init = function()
            vim.g.lazygit_floating_window_scaling_factor = 0.9  -- 90% of the screen

            -- Our global terminal mapping (Esc Esc = leave terminal mode) would make every
            -- single Esc wait before reaching LazyGit. Inside LazyGit, send Esc straight through.
            vim.api.nvim_create_autocmd("TermOpen", {
                group = vim.api.nvim_create_augroup("ZeroLazyGitEsc", { clear = true }),
                callback = function(Args)
                    if vim.api.nvim_buf_get_name(Args.buf):find("lazygit", 1, true) then
                        vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = Args.buf, nowait = true })
                    end
                end,
            })
        end,
    },
}
