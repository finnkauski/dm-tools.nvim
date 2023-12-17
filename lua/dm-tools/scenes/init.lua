require("dm-tools.scenes.generator")
local utils = require("dm-tools.utils")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

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

  local response = utils.exec("/scene/get/" .. name)

  if raw then
    return utils.parse(response)
  end

  if response.status ~= 200 then
    utils.debug(response)
  end
end

M.get_scene = get_scene

--- Set new scene
--- @param scene string
--- @param raw boolean
local function set_scene(scene, raw)
  local name = scene or vim.fn.input("Scene name: ")

  local response = utils.exec("/scene/set/" .. name, "put")

  if raw then
    return utils.parse(response)
  end

  return utils.debug(response)
end

M.set_scene = set_scene

--- Make a scene picker from a dictionary of scenes
--- @param data table
local function scene_picker(data)
  local results = {}
  for key, value in pairs(data) do
    value["identifier"] = key
    table.insert(results, value)
  end

  utils.new_picker(results, default_scene_entry_maker, function(prompt_bufnr, _)
    actions.select_default:replace(function()
      actions.close(prompt_bufnr)
      local selection = action_state.get_selected_entry()
      set_scene(selection.value["identifier"], false)
    end)
    return true
  end, scene_entry_preview)
end

--- List all scenes and set the selected one
--- @param raw boolean
M.groups = function(raw)
  local response = utils.exec("/scene/groups")

  local data = utils.parse(response).data

  if raw then
    return data
  end

  if response.status == 200 then
    local groups = {}
    for key, _ in pairs(data) do
      table.insert(groups, key)
    end

    utils.new_picker(groups, nil, function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        scene_picker(data[selection.value])
      end)
      return true
    end, nil)
  else
    utils.debug(response)
  end
end

--- List all scenes and set the selected one
--- @param raw boolean
M.set = function(raw)
  local response = utils.exec("/scene/list")

  local data = utils.parse(response).data

  if raw then
    return data
  end

  if response.status == 200 then
    scene_picker(data)
  else
    utils.debug(response)
  end
end

return M
