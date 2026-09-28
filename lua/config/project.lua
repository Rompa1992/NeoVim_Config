local M = {}

-- Returns the full path to <build_dir>/bin/<name>.exe (or <build_dir>/<name>.exe), or nil
function M.find_exe(build_dir, name)
    local root = vim.fn.getcwd() .. "/" .. build_dir

    for _, dir in ipairs({ root .. "/bin", root }) do
        local path = dir .. "/" .. name .. ".exe"
        if vim.fn.filereadable(path) == 1 then
            return path
        end
    end

    return nil
end

return M
