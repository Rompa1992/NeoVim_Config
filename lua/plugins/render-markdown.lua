return {
    {
        -- Render Markdown
        -- Draws .md files properly inside Neovim: tables as boxes, coloured headings,
        -- Obsidian callouts, and backticks and link brackets hidden.
        -- The line the cursor is on shows its raw text, so editing still works.
        -- Use: turns on by itself in .md files
        --      Space m  toggle between the drawn view and the raw text
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ft = { "markdown" },
        opts = {},

        keys = {
            { "<leader>m", "<cmd>RenderMarkdown toggle<CR>", ft = "markdown", desc = "Toggle Markdown view" },
        },
    },
}
