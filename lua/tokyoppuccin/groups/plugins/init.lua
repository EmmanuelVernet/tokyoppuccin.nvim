-- tokyoppuccin — plugin integrations dispatch.
-- Add a plugin's file name here after creating groups/plugins/<name>.lua.
-- Deliberately dumb: no all/auto machinery until a real need shows up.

local M = {}

M.enabled = {
  "snacks",
}

function M.get(c, opts)
  local out = {}
  for _, name in ipairs(M.enabled) do
    for k, v in pairs(require("tokyoppuccin.groups.plugins." .. name)(c, opts)) do
      out[k] = v
    end
  end
  return out
end

return M
