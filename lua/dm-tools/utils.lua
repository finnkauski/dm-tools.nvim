local config = require("dm-tools.config")
local M = {}

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

return M
