local utils = require("dm-tools.utils")

local M = {}

M.all = function(raw)
  local response = utils.fetch("/scene/groups")

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

return M
