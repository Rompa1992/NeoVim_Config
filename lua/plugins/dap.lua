return {
    {
        -- DAP (debugger)
        -- Breakpoints and stepping inside Neovim, using codelldb
        -- Use: F5 build + debug Game.exe, or continue if already debugging
        --      Space + dt  build + debug ZeroTests.exe
        --      Shift+F5 stop
        --      F9 breakpoint          F10 step over
        --      F11 step into          F12 step out
        --      Space + dq  stop (backup)
        --      Space + dc  clear all breakpoints
        --      Space + du  toggle debugger panels
        --      Space + db  conditional breakpoint: stops only when a condition is true
        --      Space + dl  log point: prints a message instead of stopping
        --      Space + dh  hover: the value under the cursor, expandable
        --      Space + dw  add the expression under the cursor to Watches
        --      Space + ds  scopes in a big floating window, q closes it
        --      Space + dr  run to the cursor's line
        -- Breakpoints are saved per file and come back next time.
        -- In the panel: S Scopes, W Watches, T Threads, B Breakpoints, R REPL; g? lists that view's keys
        "mfussenegger/nvim-dap",

        dependencies = {
            { "igorlfs/nvim-dap-view", version = "1.*" },
            "Weissle/persistent-breakpoints.nvim",
        },

        config = function()
            local dap = require("dap")
            local dapview = require("dap-view")
            local breakpoints = require("persistent-breakpoints.api")
            local widgets = require("dap.ui.widgets")

            -- One panel along the bottom, with tabs. Opens when debugging starts, closes when it ends.
            dapview.setup({
                winbar = {
                    sections = { "scopes", "watches", "threads", "breakpoints", "repl" },
                    default_section = "scopes",
                },
                windows = {
                    size = 0.35,
                    position = "below",
                    -- codelldb sends program output to the REPL, so its terminal window would stay empty
                    terminal = { hide = { "codelldb" } },
                },
                render = {
                    breakpoints = { align = true },
                    threads = { align = true },
                },
                auto_toggle = true,
            })

            -- Breakpoints saved to disk, reloaded when a file opens
            require("persistent-breakpoints").setup({
                load_breakpoints_event = { "BufReadPost" },
            })

            -- Signs in the left column, and the stopped line highlighted
            local function SetDebugHighlights()
                vim.api.nvim_set_hl(0, "DapBreakpoint", { link = "DiagnosticError" })
                vim.api.nvim_set_hl(0, "DapBreakpointCondition", { link = "DiagnosticWarn" })
                vim.api.nvim_set_hl(0, "DapLogPoint", { link = "DiagnosticInfo" })
                vim.api.nvim_set_hl(0, "DapBreakpointRejected", { link = "Comment" })
                vim.api.nvim_set_hl(0, "DapStopped", { link = "DiagnosticOk" })
                vim.api.nvim_set_hl(0, "DapStoppedLine", { link = "Visual" })
            end
            SetDebugHighlights()
            vim.api.nvim_create_autocmd("ColorScheme", { callback = SetDebugHighlights })

            vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
            vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition" })
            vim.fn.sign_define("DapLogPoint", { text = "■", texthl = "DapLogPoint" })
            vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpointRejected" })
            vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine" })

            -- q closes nvim-dap's floating windows, like the scopes float
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "dap-float",
                callback = function(Args)
                    vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = Args.buf, silent = true })
                end,
            })

            -- Point straight at codelldb.exe inside Mason's install folder
            local codelldb = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb.exe"

            -- ZeroEngine's LLDB formatters, so TArray and TFixedArray show their elements.
            -- Found next to this config: <config>/lldb/ZeroFormatters.py
            local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h:h:h")
            local zero_formatters = (config_dir .. "/lldb/ZeroFormatters.py"):gsub("\\", "/")

            -- Start codelldb as a server on a free port, then connect to it
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = codelldb,
                    args = { "--port", "${port}" },
                    detached = false, -- required on Windows
                },
            }

            -- Base launch settings. The exe path is filled in per launch (see start_debugging).
            local function make_config(exe)
                return {
                    name = "Launch " .. exe,
                    type = "codelldb",
                    request = "launch",
                    program = exe,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                    terminal = "console", -- program output goes to the debug console panel
                    initCommands = { 'command script import "' .. zero_formatters .. '"' },
                }
            end

            -- Save, build Debug, find <exe_name>.exe in build/, and start debugging it
            local function start_debugging(exe_name)
                if not require("config.build").Build("debug") then return end

                local exe = require("config.build").ExePath("debug", exe_name)
                if not exe then
                    vim.notify("No " .. exe_name .. " found in build/bin/", vim.log.levels.ERROR)
                    return
                end
                exe = vim.fn.fnamemodify(exe, ":p") -- codelldb needs a full path

                vim.cmd("cclose")
                dap.run(make_config(exe))
            end

            -- F5: continue if already debugging, otherwise build and debug the game
            local function debug_game()
                if dap.session() then
                    dap.continue()
                    return
                end
                start_debugging("Game")
            end

            local function debug_tests()
                start_debugging("ZeroTests")
            end

            -- Stop the program and close the panels
            local function stop()
                dap.terminate()
                dapview.close(true)
            end

            local map = vim.keymap.set
            map("n", "<F5>", debug_game, { desc = "Debug: build + debug Game / continue" })
            map("n", "<leader>dt", debug_tests, { desc = "Debug: build + debug ZeroTests" })
            map("n", "<S-F5>", stop, { desc = "Debug: stop" })
            map("n", "<F9>", breakpoints.toggle_breakpoint, { desc = "Debug: breakpoint" })
            map("n", "<F10>", dap.step_over, { desc = "Debug: step over" })
            map("n", "<F11>", dap.step_into, { desc = "Debug: step into" })
            map("n", "<F12>", dap.step_out, { desc = "Debug: step out" })
            map("n", "<leader>dq", stop, { desc = "Debug: stop" })
            map("n", "<leader>dc", breakpoints.clear_all_breakpoints, { desc = "Debug: clear all breakpoints" })
            map("n", "<leader>du", dapview.toggle, { desc = "Debug: toggle panels" })
            map("n", "<leader>db", breakpoints.set_conditional_breakpoint, { desc = "Debug: conditional breakpoint" })
            map("n", "<leader>dl", breakpoints.set_log_point, { desc = "Debug: log point" })
            map("n", "<leader>dh", function() dapview.hover() end, { desc = "Debug: hover value" })
            map("n", "<leader>dw", "<Cmd>DapViewWatch<CR>", { desc = "Debug: watch expression" })
            map("n", "<leader>ds", function() widgets.centered_float(widgets.scopes) end, { desc = "Debug: scopes, floating" })
            map("n", "<leader>dr", dap.run_to_cursor, { desc = "Debug: run to cursor" })
        end,
    },
}
