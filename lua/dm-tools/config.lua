local M = {}

local config = {
  toolkit_server_url = "http://localhost:8888",
}

--- Get a configuration value
--- @param opt string
--- @return any
M.get = function(opt)
  -- If an option was passed then
  -- return the requested option.
  -- Otherwise, return the entire
  -- configurations.
  if opt then
    return config[opt]
  end

  return config
end

--- Set user-defined configurations
--- @param user_configs table
--- @return table
M.set = function(user_configs)
  vim.validate({ user_configs = { user_configs, "table" } })

  config = vim.tbl_deep_extend("force", config, user_configs)
  return config
end

return M
