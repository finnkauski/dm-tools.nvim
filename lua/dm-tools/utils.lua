-- telescope stuff
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

-- Local
local config = require("dm-tools.config")

local M = {}

--- @param response table
M.parse = function(response)
  return vim.json.decode(response.body, {})
end

--- Debug a table in a new window
--- @param response table
M.debug = function(response)
  print(vim.inspect(vim.json.decode(response.body, {})))
end

--- Debug a table in a new window
--- @param path string
M.toolkit_url = function(path)
  return config.get("toolkit_server_url") .. path
end

--- Make picker
--- @param results table
--- @param entry_maker function
--- @param exec_fn function
--- @param opts table
M.new_picker = function(results, entry_maker, exec_fn, opts)
  exec_fn = exec_fn or function() end
  opts = opts or require("telescope.themes").get_dropdown({})
  entry_maker = entry_maker
    or function(entry)
      return {
        value = entry,
        display = entry[1],
        ordinal = entry[1],
      }
    end
  pickers
    .new(opts, {
      prompt_title = "colors",
      finder = finders.new_table({
        results = results,
        entry_maker = entry_maker,
      }),
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, _)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          exec_fn(selection)
        end)
        return true
      end,
    })
    :find()
end

return M
