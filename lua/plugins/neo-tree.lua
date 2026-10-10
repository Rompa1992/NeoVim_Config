return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            filesystem = {
                -- The tree jumps to, and highlights, whichever file you're editing
                follow_current_file = { enabled = true },
            },
        },
        init = function()
            -- Entering the tree always lands in Normal mode, so Enter, o and the arrows
            -- open and expand nodes even if you came from Insert mode in a code window.
            vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
                group = vim.api.nvim_create_augroup("ZeroNeoTreeNormal", { clear = true }),
                callback = function()
                    if vim.bo.filetype == "neo-tree" then
                        vim.cmd("stopinsert")
                    end
                end,
            })
        end,
    },
}
