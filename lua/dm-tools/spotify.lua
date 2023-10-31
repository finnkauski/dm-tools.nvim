local curl = require("plenary.curl")
local utils = require("dm-utils.utils")

M = {}

--- Login to Spotify
M.login = function()
  return utils.debug(curl.get({
    url = utils.toolkit_url("/spotify/login"),
  }))
end

return M
