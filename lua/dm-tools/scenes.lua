local curl = require("plenary.curl")
local utils = require("dm-utils.utils")

M = {}

--- List all scenes
M.list = function()
  return utils.debug(curl.get({
    url = utils.toolkit_url("/scene/list"),
  }))
end

--- List all groups
M.groups = function()
  return utils.debug(curl.get({
    url = utils.toolkit_url("/scene/groups"),
  }))
end

--- Get current scene
M.get = function()
  return utils.debug(curl.get({
    url = utils.toolkit_url("/scene/"),
  }))
end

--- Set new scene
M.set = function()
  local name = vim.fn.input("Scene name: ")
  return utils.debug(curl.put({
    url = utils.toolkit_url("/scene/set/" .. name),
  }))
end

return M
