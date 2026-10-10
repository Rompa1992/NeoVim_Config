return {
    {
        -- Quicker
        -- A better quickfix list, where build errors land: tidier columns, the code around each error,
        -- and lines you can edit in place
        -- Use: >    show the code around each error (press again for more)
        --      <    hide it again
        --      edit a line in the list, then :w writes the change into the real file
        "stevearc/quicker.nvim",
        event = "FileType qf",

        opts = {
            keys = {
                {
                    ">",
                    function() require("quicker").expand({ before = 2, after = 2, add_to_existing = true }) end,
                    desc = "Show code around errors",
                },
                { "<", function() require("quicker").collapse() end, desc = "Hide code around errors" },
            },
        },
    },
}
