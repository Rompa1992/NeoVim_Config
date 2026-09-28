return {
    {
        -- DAP (debugger)
        -- Breakpoints and stepping inside Neovim, using codelldb
        -- Use: F5 build + start debugging, or continue if already debugging
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
                    detached = false,  -- required on Windows
                },
            }

            -- What F5 launches
            dap.configurations.cpp = {
                {
                    name = "Launch Debug",
                    type = "codelldb",
                    request = "launch",

                    -- Which exe to run: finds the .exe in build/ automatically (see lua/config/project.lua)
                    program = function()
                        return require("config.project").find_exe("build")
                    end,

                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,

                    -- Program output goes to the debug console panel, not a separate terminal window
                    terminal = "console",
                },
            }

            -- Open panels when debugging starts, close when it ends
            dap.listeners.after.event_initialized["dapui"] = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui"] = function() dapui.close() end
            dap.listeners.before.event_exited["dapui"] = function() dapui.close() end

            -- F5: continue if already debugging, otherwise save, build Debug, and start
            local function build_and_debug()
                if dap.session() then
                    dap.continue()
                    return
                end

                vim.cmd("wall")
                vim.cmd("make")

                if vim.v.shell_error ~= 0 then
                    vim.cmd("copen")  -- build failed: show errors, don't debug
                    return
                end

                vim.cmd("cclose")
                dap.run(dap.configurations.cpp[1])
            end

            -- Stop the program and close the panels
            local function stop()
                dap.terminate()
                dapui.close()
            end

            local map = vim.keymap.set
            map("n", "<F5>", build_and_debug, { desc = "Debug: build + start / continue" })
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
