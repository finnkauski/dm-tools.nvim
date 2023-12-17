local curl = require("plenary.curl")
local utils = require("dm-tools.utils")

M = {}

--- Get Spotify user
--- @param raw boolean
M.user = function(raw)
  local response = utils.exec("/spotify/user")

  if raw then
    return utils.parse(response)
  end

  return utils.debug(response)
end

--- Login to Spotify
--- @param raw boolean
M.authenticated = function(raw)
  local response = utils.exec("/spotify/authenticated")

  if raw then
    return utils.parse(response)
  end

  local is_authenticated = utils.parse(response).data

  if response.status == 200 and is_authenticated then
    print("Authenticated")
  elseif response.status == 200 and not is_authenticated then
    print("Unauthenticated")
  else
    utils.debug(response)
  end
end

--- Login to Spotify
--- @param raw boolean
M.login = function(raw)
  local response = utils.exec("/spotify/login")

  if raw then
    return utils.parse(response)
  end

  if response.status == 200 then
    print("Please see your browser for login screen")
  else
    utils.debug(response)
  end
end

--- Logoff to Spotify
--- @param raw boolean
M.logout = function(raw)
  local response = utils.exec("/spotify/logout")

  if raw then
    return utils.parse(response)
  end

  if response.status == 200 then
    print("Logged out.")
  else
    utils.debug(response)
  end
end

--- Pause Spotify
--- @param raw boolean
M.pause = function(raw)
  local response = utils.exec("/spotify/pause")

  if raw then
    return utils.parse(response)
  end

  if response.status == 200 then
    print("Paused")
  else
    utils.debug(response)
  end
end

--- Resume Spotify
--- @param raw boolean
M.resume = function(raw)
  local response = utils.exec("/spotify/resume")

  if raw then
    return utils.parse(response)
  end

  if response.status == 200 then
    print("► Resumed")
  else
    utils.debug(response)
  end
end

return M
