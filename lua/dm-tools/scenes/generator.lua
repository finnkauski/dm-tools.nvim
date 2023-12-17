local utils = require("dm-tools.utils")
local lights = require("dm-tools.lights")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local action_utils = require("telescope.actions.utils")

local M = {}

-- {
--   "name": "Altar",
--   "lights": {
--     "9" : { "on": true, "bri": 149, "color_space_coordinates": [0.6176, 0.3136] },
--     "8" : { "on": true, "bri": 195, "color_space_coordinates": [0.172, 0.747] }
--   },
--   "spotify": { "volume_percent":100, "context_uri": "spotify:playlist:37i9dQZF1DXa71eg5j9dKZ" }
-- }

local light_to_entry = function(light)
  local display = light.id .. " " .. light.name
  return {
    value = light,
    display = display,
    ordinal = display,
  }
end

local scene_previewer = function(entry)
  local info = {
    "ID: " .. entry.value.id,
    "NAME: " .. entry.value.name,
    "----------",
  }
  for key, value in pairs(entry.value.state) do
    if key ~= "color_space_coordinates" then
      table.insert(info, string.upper(key) .. ": " .. tostring(value))
    else
      table.insert(info, string.upper(key) .. ": " .. vim.json.encode(value))
    end
  end

  return info
end

--- Turn a table into the lines to insert
--- @param tbl table
local function table_to_lines(tbl)
  local json_string = vim.json.encode(tbl) or ""

  -- run through jq if it's available
  if vim.fn.executable("jq") == 1 then
    local obj = vim.system({ "jq", "." }, { stdin = json_string, text = true }):wait()
    if obj.stderr ~= "" then
      vim.notify(string.format("Found `jq` but could not format: %s", obj.stderr))
    else
      json_string = obj.stdout or json_string
    end
  end

  local lines = vim.split(json_string, "\n")

  return lines
end

local function finalise(scene)
  -- new buffer in a split
  vim.cmd("vsplit")
  local buf = vim.api.nvim_create_buf(true, true)
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_set_option_value("filetype", "json", { buf = buf })

  -- generate and insert our template
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, table_to_lines(scene))
end

local function add_lights(scene)
  -- we need to add a table to insert into
  if not scene.lights then
    scene.lights = {}
  end

  local data = lights.all(true)

  local function attach_mappings(prompt_bufnr, map)
    map({ "i", "n" }, "<Tab>", function()
      actions.select_default()
    end)

    map({ "i", "n" }, "<CR>", function()
      action_utils.map_selections(prompt_bufnr, function(entry, _)
        scene.lights[entry.value.id] = entry.value
      end)
      actions.close(prompt_bufnr)
      -- Remove the lights field if it's empty
      if not next(scene.lights) then
        scene.lights = nil
      end
      finalise(scene)
    end)

    actions.select_default:replace(function()
      actions.toggle_selection(prompt_bufnr)
    end)

    return true
  end

  utils.new_picker(data, light_to_entry, attach_mappings, scene_previewer)
end

--- Generate a scene JSON representation
local function _generate(scene, state)
  state = state or "start"
  scene = scene or {
    name = vim.fn.input("Name: "),
  }

  add_lights(scene)
end

vim.keymap.set("n", "<leader><leader>r", _generate)

return M
