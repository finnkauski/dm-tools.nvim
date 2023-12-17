local utils = require("dm-tools.utils")

local M = {}

M.all = function(raw)
  local response = utils.exec("/lights/all")

  local data = utils.parse(response)

  if raw then
    return data
  end
end

return M
