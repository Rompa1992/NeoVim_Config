return {
    {
        -- Alpha
        -- Start screen when Neovim opens with no file: ZeroEngine logo + shortcuts
        "goolord/alpha-nvim",
        event = "VimEnter",

        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

            dashboard.section.header.val = {
                "███████╗███████╗██████╗  ██████╗ ",
                "╚══███╔╝██╔════╝██╔══██╗██╔═══██╗",
                "  ███╔╝ █████╗  ██████╔╝██║   ██║",
                " ███╔╝  ██╔══╝  ██╔══██╗██║   ██║",
                "███████╗███████╗██║  ██║╚██████╔╝",
                "╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ",
                "                                 ",
                "        E  N  G  I  N  E         ",
            }
            dashboard.section.header.opts.hl = "ZeroLogo"

            local ConfigDir = vim.fn.stdpath("config")

            dashboard.section.buttons.val = {
                dashboard.button("f", "Find file", "<cmd>Telescope find_files<CR>"),
                dashboard.button("r", "Recent files", "<cmd>Telescope oldfiles<CR>"),
                dashboard.button("g", "Search project", "<cmd>Telescope live_grep<CR>"),
                dashboard.button("e", "File tree", "<cmd>Neotree toggle<CR>"),
                dashboard.button("c", "Neovim config", "<cmd>Telescope find_files cwd=" .. ConfigDir .. "<CR>"),
                dashboard.button("l", "Plugins (Lazy)", "<cmd>Lazy<CR>"),
                dashboard.button("q", "Quit", "<cmd>qa<CR>"),
            }

            for _, Button in ipairs(dashboard.section.buttons.val) do
                Button.opts.hl = "ZeroDashButton"
                Button.opts.hl_shortcut = "ZeroDashKey"
            end

            dashboard.section.footer.val = vim.fn.getcwd()
            dashboard.section.footer.opts.hl = "ZeroDashFooter"

            alpha.setup(dashboard.config)
        end,
    },
}
