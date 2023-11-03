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

local function scene_entry_preview(entry)
  local e = entry.value

  -- Check for Spotify
  local spotify_enabled = "No"
  if e["spotify"] ~= nil then
    spotify_enabled = "Yes"
  end

  local info = {
    "Name:    " .. e["name"],
    "Group:   " .. (e["group"] or "N/A"),
    "",
    "Spotify: " .. spotify_enabled,
  }

  -- Add the lights
  if e["lights"] ~= nil then
    table.insert(info, "Lights:  ")
    for key, _ in pairs(e["lights"]) do
      table.insert(info, "- " .. key)
    end
  end

  -- Add the links
  if e["links"] ~= nil then
    table.insert(info, "Links:   ")
    local n = 0
    for _, val in ipairs(e["links"]) do
      if n == 2 then
        break
      end
      table.insert(info, "- " .. val)
      n = n + 1
    end
    if n == 2 then
      table.insert(info, "...")
    end
  end

  return info
end

--- Get a given scene
--- @param scene string
--- @param raw boolean
local function get_scene(scene, raw)
  local name = scene or vim.fn.input("Scene name: ")

  local response = curl.get({
    url = utils.toolkit_url("/scene/get/" .. name),
  })

  if raw then
    return utils.parse(response)
  end

  return utils.debug(response)
end

M.get_scene = get_scene

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

--- Set one scene rather than listing them all
M.set_scene = set_scene

--- Make a scene picker from a dictionary of scenes
--- @param data table
local function scene_picker(data)
  local results = {}
  for key, value in pairs(data) do
    value["identifier"] = key
    table.insert(results, value)
  end

  utils.new_picker(results, default_scene_entry_maker, function(entry)
    set_scene(entry.value["identifier"], false)
  end, scene_entry_preview)
end

--- List all scenes and set the selected one
--- @param raw boolean
M.groups = function(raw)
  local response = curl.get({
    url = utils.toolkit_url("/scene/groups"),
  })

  local data = utils.parse(response).data

  if raw then
    return data
  end

  local groups = {}
  for key, _ in pairs(data) do
    table.insert(groups, key)
  end

  utils.new_picker(groups, nil, function(selection)
    scene_picker(data[selection.value])
  end, nil)
end

--- List all scenes and set the selected one
--- @param raw boolean
M.set = function(raw)
  local response = curl.get({
    url = utils.toolkit_url("/scene/list"),
  })

  local data = utils.parse(response).data

  if raw then
    return data
  end

  scene_picker(data)
end

return M
