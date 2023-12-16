-- telescope stuff
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local curl = require("plenary.curl")

-- Local
local config = require("dm-tools.config")

local M = {}

--- Set keys for normal mode, mainly a convenience
--- @param lhs string
--- @param rhs function | string
--- @param desc string
M._nmap = function(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, {
    silent = true,
    noremap = true,
    desc = desc,
  })
end

--- Parse the body of a response (usually has all we need and is json)
--- @param response table
M.parse = function(response)
  return vim.json.decode(response.body, {})
end

--- Debug a response body by printing it
--- @param response table
M.debug = function(response)
  print(vim.inspect(vim.json.decode(response.body, {})))
end

--- Debug a table in a new window
--- @param path string
M.toolkit_url = function(path)
  return config.values.toolkit_server_url .. path
end

--- Make a request fetcher function
--- @param endpoint string
M.fetch = function(endpoint)
  curl.get({
    url = M.toolkit_url(endpoint),
  })
end

--- Make picker and run it
--- @param results table
--- @param entry_maker function
--- @param exec_fn function
--- @param gen_preview_lines function
--- @param opts table
M.new_picker = function(results, entry_maker, exec_fn, gen_preview_lines, opts)
  opts = opts or require("telescope.themes").get_dropdown()
  exec_fn = exec_fn or function(_) end

  -- Previewer logic
  local previewer = nil
  if gen_preview_lines ~= nil then
    previewer = previewers.new_buffer_previewer({
      define_preview = function(self, entry, _)
        local lines = gen_preview_lines(entry)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
      end,
    })
  end

  -- Instantiate a picker
  pickers
    .new(opts, {
      finder = finders.new_table({
        results = results,
        entry_maker = entry_maker,
      }),
      previewer = previewer,
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
