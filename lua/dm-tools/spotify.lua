local curl = require("plenary.curl")
local utils = require("dm-tools.utils")

M = {}

--- Get Spotify user
--- @param raw boolean
M.user = function(raw)
  local response = curl.get({
    url = utils.toolkit_url("/spotify/user"),
  })

  if raw then
    return utils.parse(response)
  end

  return utils.debug(response)
end

--- Login to Spotify
--- @param raw boolean
M.authenticated = function(raw)
  local response = curl.get({
    url = utils.toolkit_url("/spotify/authenticated"),
  })

  if raw then
    return utils.parse(response)
  end

  local is_authenticated = utils.parse(response).data

  if response.status == 200 and is_authenticated then
    print("Spotify authenticated")
  else
    utils.debug(response)
  end
end

--- Login to Spotify
--- @param raw boolean
M.login = function(raw)
  local response = curl.get({
    url = utils.toolkit_url("/spotify/login"),
  })

  if raw then
    return utils.parse(response)
  end

  if response.status == 200 then
    print("Please see your browser for login screen.")
  else
    utils.debug(response)
  end
end

--- Logoff to Spotify
--- @param raw boolean
M.logout = function(raw)
  local response = curl.get({
    url = utils.toolkit_url("/spotify/logout"),
  })

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
  local response = curl.get({
    url = utils.toolkit_url("/spotify/pause"),
  })

  if raw then
    return utils.parse(response)
  end

  if response.status == 200 then
    print("Paused.")
  else
    utils.debug(response)
  end
end

--- Resume Spotify
--- @param raw boolean
M.resume = function(raw)
  local response = curl.get({
    url = utils.toolkit_url("/spotify/resume"),
  })

  if raw then
    return utils.parse(response)
  end

  if response.status == 200 then
    print("► Resumed.")
  else
    utils.debug(response)
  end
end

return M
