return {
    {
        -- DAP virtual text
        -- Shows variable values inline next to your code while debugging
        "theHamsta/nvim-dap-virtual-text",

        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-treesitter/nvim-treesitter",
        },

        opts = {
            virt_text_pos = "eol",              -- after the code, so the line itself never shifts
            highlight_changed_variables = true, -- a value that just changed stands out
            highlight_new_as_changed = true,
        },
    },
}
