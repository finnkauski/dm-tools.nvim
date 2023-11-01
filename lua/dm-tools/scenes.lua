local curl = require("plenary.curl")
local utils = require("dm-tools.utils")

-- Top level module table
M = {}

--- Make default entry maker to translate a
--- @param entry table
local default_scene_entry_maker = function(entry)
  local group = (entry["group"] or "")
  if group ~= "" then
    group = " (" .. group .. ")"
  end
  local name = entry["name"] .. group
  return {
    value = entry,
    display = name,
    ordinal = name,
  }
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
local function set_scene(scene, raw)
  local name = scene or vim.fn.input("Scene name: ")

  local response = curl.put({
    url = utils.toolkit_url("/scene/set/" .. name),
  })

  if raw then
    return utils.parse(response)
  end

  return utils.debug(response)
end

M.set = set_scene

--- List all scenes
--- @param raw boolean
M.list = function(raw)
  local response = curl.get({
    url = utils.toolkit_url("/scene/list"),
  })

  local data = utils.parse(response).data

  if raw then
    return data
  end

  local results = {}
  for key, value in pairs(data) do
    value["identifier"] = key
    table.insert(results, value)
  end

  -- picker setup
  utils.new_picker(results, default_scene_entry_maker, function(entry)
    set_scene(entry.value["identifier"], false)
  end, {})
end

return M
