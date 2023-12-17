local scenes = require("dm-tools.scenes")
local spotify = require("dm-tools.spotify")
local lights = require("dm-tools.lights")

local utils = require("dm-tools.utils")
local config = require("dm-tools.config")

local M = {}

M.scenes = scenes
M.spotify = spotify

--- Sets some basic useful keymaps
M.set_default_keymaps = function()
  utils._nmap("<leader>dmsg", scenes.groups, "Groups")
  utils._nmap("<leader>dmss", scenes.set, "Scenes")
  utils._nmap("<leader>dmsg", scenes.generate_scene, "Generate a new scene")
  utils._nmap("<leader>dmsd", utils.open_scene_directory, "Scene directory")
  utils._nmap("<leader>dmml", spotify.login, "Login to Spotify")
  utils._nmap("<leader>dmmx", spotify.logout, "Logout from Spotify")
  utils._nmap("<leader>dmmu", spotify.user, "Get Spotify user")
  utils._nmap("<leader>dmma", spotify.authenticated, "Check if Spotify is authenticated")
  utils._nmap("<leader>dmmp", spotify.pause, "Pause Spotify")
  utils._nmap("<leader>dmmr", spotify.resume, "Resume Spotify")
  utils._nmap("<leader>dml", lights.all, "Get all lights")
end

--- Setup is the public method to setup your plugin
--- @param opts table
M.setup = function(opts)
  config.set(opts or {})

  -- Set keymaps if not stopped
  if config.values.set_keymap then
    M.set_default_keymaps()
  end
end

return M
