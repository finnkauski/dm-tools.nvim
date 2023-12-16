local M = {}

-- {
--   "name": "Altar",
--   "lights": {
--     "9" : { "on": true, "bri": 149, "color_space_coordinates": [0.6176, 0.3136] },
--     "8" : { "on": true, "bri": 195, "color_space_coordinates": [0.172, 0.747] }
--   },
--   "spotify": { "volume_percent":100, "context_uri": "spotify:playlist:37i9dQZF1DXa71eg5j9dKZ" }
-- }

--- Take a scene and add the lights component
--- @param scene table
local function add_lights(scene)
  local lights = {}
  local continue = true
  -- TODO: use telescope to get the lights state and choose those using it.
  while continue do
    local light = vim.fn.input('Add light with id ("c" to continue): ')
    if light == "c" then
      continue = false
    elseif not tonumber(light) then
      vim.notify("Not a number provided. Skipping...")
    else
      lights[light] = {}
    end
  end
  if #lights ~= 0 then
    scene.lights = lights
  end
end

--- Generate a scene JSON representation
local function generate_scene()
  local scene = {
    name = vim.fn.input("Name: "),
  }

  if vim.fn.input("Include lights? ") == "y" then
    add_lights(scene)
  end

  return scene
end

--- Turn a table into the lines to insert
--- @param tbl table
local function table_to_lines(tbl)
  local json_string = vim.json.encode(tbl) or ""

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

M.new_scene = function()
  -- new buffer in a split
  vim.cmd("vsplit")
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_win_set_buf(win, buf)
  -- set the filetype
  vim.api.nvim_set_option_value("filetype", "json", { buf = buf })

  -- generate and insert our template
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, table_to_lines(generate_scene()))
end

vim.keymap.set("n", "<leader>r", M.new_scene)

return M
