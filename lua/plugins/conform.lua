return {
    {
        -- Conform
        -- Formats C++ with clang-format, using the repo's .clang-format, ONLY when you press Space cf.
        -- Never on save: formatting half-written code mangled MotorBreath.cpp.
        -- Needs the clang-format program: :MasonInstall clang-format
        -- Without it, falls back to clangd's built-in formatter, which reads the same .clang-format.
        -- Use: Space cf          format now
        "stevearc/conform.nvim",
        cmd = { "ConformInfo" },

        opts = {
            formatters_by_ft = {
                c = { "clang-format" },
                cpp = { "clang-format" },
            },

        },
    },
}
