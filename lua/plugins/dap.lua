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
        "mfussenegger/nvim-dap",

        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },

        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            dapui.setup()

            -- Point straight at codelldb.exe inside Mason's install folder
            local codelldb = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb.exe"

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
                }
            end

            -- Open panels when debugging starts, close when it ends
            dap.listeners.after.event_initialized["dapui"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui"] = function()
                dapui.close()
            end

            -- Save, build Debug, find <exe_name>.exe in build/, and start debugging it
            local function start_debugging(exe_name)
                vim.cmd("wall")
                if not require("config.build").Build("debug") then return end

                if vim.v.shell_error ~= 0 then
                    vim.cmd("copen") -- build failed: show errors, don't debug
                    return
                end

                local exe = require("config.project").find_exe("build", exe_name)
                if not exe then
                    vim.notify("No " .. exe_name .. ".exe found in build/", vim.log.levels.ERROR)
                    return
                end

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
                dapui.close()
            end

            local map = vim.keymap.set
            map("n", "<F5>", debug_game, { desc = "Debug: build + debug Game / continue" })
            map("n", "<leader>dt", debug_tests, { desc = "Debug: build + debug ZeroTests" })
            map("n", "<S-F5>", stop, { desc = "Debug: stop" })
            map("n", "<F9>", dap.toggle_breakpoint, { desc = "Debug: breakpoint" })
            map("n", "<F10>", dap.step_over, { desc = "Debug: step over" })
            map("n", "<F11>", dap.step_into, { desc = "Debug: step into" })
            map("n", "<F12>", dap.step_out, { desc = "Debug: step out" })
            map("n", "<leader>dq", stop, { desc = "Debug: stop" })
            map("n", "<leader>dc", dap.clear_breakpoints, { desc = "Debug: clear breakpoints" })
            map("n", "<leader>du", dapui.toggle, { desc = "Debug: toggle panels" })
        end,
    },
}
