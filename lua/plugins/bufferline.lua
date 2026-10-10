return {
    {
        -- Bufferline
        -- Shows open files as tabs across the top
        -- Use: Space + a    next file
        --      Space + x    close current file (keeps the window layout)
        --      Click X / right-click a tab: close that file (keeps the window layout)
        --      Space + <    move this tab left        Space + >   move this tab right
        --      Space + p    pin this tab: pinned tabs sit at the front and never close by themselves
        -- Files the debugger or a build error opened get no tab until you edit them (config/preview.lua)
        "akinsho/bufferline.nvim",
        version = "*",

        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "nvim-mini/mini.bufremove", -- deletes a buffer without closing its window
        },

        opts = {
            options = {
                diagnostics = "nvim_lsp", -- show error counts on each tab

                -- Leave room for neo-tree so tabs start to the right of it
                offsets = {
                    { filetype = "neo-tree", text = "Files", separator = true },
                },

                -- Previews get no tab (config/preview.lua)
                custom_filter = function(Buffer)
                    return not require("config.preview").IsPreview(Buffer)
                end,

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
            require("config.preview") -- sets up preview files before any file opens
            require("bufferline").setup(opts)

            vim.keymap.set("n", "<leader>a", "<cmd>BufferLineCycleNext<CR>", { desc = "Next file" })
            vim.keymap.set("n", "<leader><", "<cmd>BufferLineMovePrev<CR>", { desc = "Move tab left" })
            vim.keymap.set("n", "<leader>>", "<cmd>BufferLineMoveNext<CR>", { desc = "Move tab right" })

            -- Space + p: pin. A pinned file is never a preview, so it always keeps its tab
            vim.keymap.set("n", "<leader>p", function()
                require("config.preview").Keep(0)
                vim.cmd("BufferLineTogglePin")
            end, { desc = "Pin tab" })

            -- Space + x: close the current file but keep the window (plain :bdelete would close the window too)
            vim.keymap.set("n", "<leader>x", function()
                require("mini.bufremove").delete(0, false)
            end, { desc = "Close file" })
        end,
    },
}
