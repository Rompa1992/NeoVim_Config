return {
    {
        -- Lualine
        -- Status bar at the bottom: mode, git branch, changes, errors, file, position
        -- Coloured from lua/config/palette.lua, mode colours match the line number
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",

        opts = function()
            local c = require("config.palette")

            -- One mode block colour, shared middle/right sections
            local function Mode(Colour)
                return {
                    a = { fg = c.bg_hard, bg = Colour, gui = "bold" },
                    b = { fg = c.fg, bg = c.surface2 },
                    c = { fg = c.fg_soft, bg = c.surface1 },
                }
            end

            local ZeroTheme = {
                normal  = Mode(c.mode_normal),
                insert  = Mode(c.mode_insert),
                visual  = Mode(c.mode_visual),
                replace = Mode(c.mode_replace),
                command = Mode(c.mode_command),
                inactive = {
                    a = { fg = c.gray, bg = c.bg_dim },
                    b = { fg = c.gray, bg = c.bg_dim },
                    c = { fg = c.gray, bg = c.bg_dim },
                },
            }

            return {
                options = {
                    theme = ZeroTheme,
                    icons_enabled = true,         -- set false if icons show as boxes
                    section_separators = "",
                    component_separators = "|",
                    globalstatus = true,          -- one status bar for all windows
                },

                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        "branch",
                        {
                            "diff",
                            diff_color = {
                                added    = { fg = c.mode_insert },
                                modified = { fg = c.string_yellow },
                                removed  = { fg = c.red },
                            },
                        },
                        {
                            "diagnostics",
                            diagnostics_color = {
                                error = { fg = c.red },
                                warn  = { fg = c.string_yellow },
                                info  = { fg = c.prussian_light },
                                hint  = { fg = c.gray },
                            },
                        },
                    },
                    lualine_c = { { "filename", path = 1 } },  -- path relative to project
                    lualine_x = { "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            }
        end,
    },
}
