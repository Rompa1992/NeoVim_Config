return {
    {
        -- Flash
        -- Jump anywhere on screen: press s, type the first letters of where you want to go,
        -- then the highlighted label letter
        -- Use: s    jump
        --      S    select a whole syntax block, such as a function or an if
        --      f/t  also show labels, so repeated matches are one key away
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {},

        keys = {
            { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
            { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash select block" },
        },
    },
}
