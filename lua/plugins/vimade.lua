return {
    {
        -- Vimade
        -- Fades the code in every window except the one you're in, so it's obvious where the cursor is
        -- and the other windows stop competing for attention.
        -- Use: works by itself
        --      :VimadeToggle   turn fading off or on
        "TaDaa/vimade",
        event = "VeryLazy",
        opts = {
            ncmode = "windows",  -- fade every inactive window, even one showing the same file
            fadelevel = 0.5,     -- 0 is invisible, 1 is no fade
        },
    },
}
