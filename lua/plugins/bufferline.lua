return {
    {
        -- Bufferline
        -- Shows open files as tabs across the top
        -- Use: Space + d    previous file
        --      Space + a    next file
        --      Space + x    close current file (keeps the window layout)
        --      Click X / right-click a tab: close that file (keeps the window layout)
        "akinsho/bufferline.nvim",
        version = "*",

        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "echasnovski/mini.bufremove", -- deletes a buffer without closing its window
        },

        opts = {
            options = {
                diagnostics = "nvim_lsp", -- show error counts on each tab

                -- Leave room for neo-tree so tabs start to the right of it
                offsets = {
                    { filetype = "neo-tree", text = "Files", separator = true },
                },

                -- Clicking X / right-click on a tab: delete the buffer, keep the window layout
                close_command = function(Buffer)
                    require("mini.bufremove").delete(Buffer, false)
                end,
                right_mouse_command = function(Buffer)
                    require("mini.bufremove").delete(Buffer, false)
                end,
            },
        },

        config = function(_, opts)
            require("bufferline").setup(opts)

            vim.keymap.set("n", "<leader>d", "<cmd>BufferLineCyclePrev<CR>", { desc = "Previous file" })
            vim.keymap.set("n", "<leader>a", "<cmd>BufferLineCycleNext<CR>", { desc = "Next file" })

            -- Space + x: close the current file but keep the window (plain :bdelete would close the window too)
            vim.keymap.set("n", "<leader>x", function()
                require("mini.bufremove").delete(0, false)
            end, { desc = "Close file" })
        end,
    },
}
