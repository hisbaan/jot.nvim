local scan = require('plenary.scandir')

local M = {}

--- @class JotConfig
--- @field search_dir? string Directory to look for notes in
--- @field search_depth? number Recursive search depth
--- @field hide_search_dir? boolean Show or hide the search directory in the selection ui
--- @field post_open_hook? function Function to run after opening
local defaults = {
    search_dir = "~/Documents/",
    search_depth = 5,
    hide_search_dir = false,
    post_open_hook = function() end,
}

--- @type JotConfig
local config = {}

--- Setup configuration and use defaults for undefined values
--- @param opts? JotConfig User configuration
function M.setup(opts)
    opts = opts or {}

    config.search_dir = opts.search_dir or defaults.search_dir
    config.search_depth = opts.search_depth or defaults.search_depth
    config.hide_search_dir = opts.hide_search_dir or defaults.hide_search_dir
    config.post_open_hook = opts.post_open_hook or defaults.post_open_hook

    vim.api.nvim_create_user_command(
        "Jot",
        M.search,
        {
            desc = "Seach for your notes",
            nargs = 0
        }
    )
end

--- Search for notes and open using vim.ui.select
function M.search()
    local home = os.getenv("HOME") or "$HOME"
    local files = scan.scan_dir(
        config.search_dir:gsub("~", home),
        { hidden = true, depth = config.search_depth }
    )

    for i = 1, #files do
        local file = vim.fn.resolve(files[i])
        file = file:gsub(home, "~")
        if config.hide_search_dir then
            file = file:gsub(config.search_dir, "")
        end
        files[i] = file
    end

    vim.ui.select(files, {
        prompt = "Select note to edit",
    },
        function(choice)
            if config.hide_search_dir then
                choice = vim.fn.resolve(config.search_dir .. "/" .. choice)
            end
            vim.cmd(":e " .. choice)
            config.post_open_hook()
        end
    )
end

return M
