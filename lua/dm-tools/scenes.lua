local curl = require("plenary.curl")
local utils = require("dm-tools.utils")

-- Top level module table
M = {}

--- List all scenes
--- @param raw boolean
M.list = function(raw)
  local response = curl.get({
    url = utils.toolkit_url("/scene/list"),
  })

  if raw then
    return utils.parse(response)
  end

  return utils.debug(response)
end

--- List all groups
--- @param raw boolean
M.groups = function(raw)
  local response = curl.get({
    url = utils.toolkit_url("/scene/groups"),
  })

  if raw then
    return utils.parse(response)
  end

  return utils.debug(response)
end

--- Get a given scene
--- @param scene string
--- @param raw boolean
M.get = function(scene, raw)
  local name = scene or vim.fn.input("Scene name: ")

  local response = curl.get({
    url = utils.toolkit_url("/scene/get/" .. name),
  })

  if raw then
    return utils.parse(response)
  end

  return utils.debug(response)
end

--- Set new scene
--- @param scene string
--- @param raw boolean
M.set = function(scene, raw)
  local name = scene or vim.fn.input("Scene name: ")

  local response = curl.put({
    url = utils.toolkit_url("/scene/set/" .. name),
  })

  if raw then
    return utils.parse(response)
  end

  return utils.debug(response)
end

return M
