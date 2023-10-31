local scenes = require("dm-utils.scenes")
local spotify = require("dm-utils.spotify")
local config = require("dm-utils.config")

local M = {}

--- Setup is the public method to setup your plugin
--- @param user_configs table
M.setup = function(user_configs)
  config.set(user_configs or {})
end

M.scenes = scenes
M.spotify = spotify

return M
