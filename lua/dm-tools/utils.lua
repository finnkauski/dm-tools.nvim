-- telescope stuff
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
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
M.exec = function(endpoint, method)
  method = method or "get"
  return curl[method]({
    url = M.toolkit_url(endpoint),
  })
end

--- Make picker and run it
--- @param results table This is what is going to be the entry in the list
--- @param entry_maker function takes a value from results, outputs entry
--- @param attach_mappings function takes entry, does something
--- @param gen_preview_lines function takes entry generates preview
--- @param opts table
M.new_picker = function(results, entry_maker, attach_mappings, gen_preview_lines, opts)
  opts = opts or require("telescope.themes").get_dropdown()
  attach_mappings = attach_mappings or function(_) end

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
      attach_mappings = attach_mappings,
    })
    :find()
end

--- Open scene directory as it is configured
M.open_scene_directory = function()
  vim.cmd("e" .. config.values.scene_directory)
end

return M
