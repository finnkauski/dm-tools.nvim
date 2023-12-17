local M = {}

M.values = {
  default_keymap = true,
  toolkit_server_url = "http://localhost:8888",
  scene_directory = "~/.dm-toolkit/scenes",
}

--- Set user-defined configurations
--- @param opts table
--- @return table
M.set = function(opts)
  vim.validate({ opts = { opts, "table" } })

  M.values = vim.tbl_deep_extend("force", M.values, opts)
  return M.values
end

return M
