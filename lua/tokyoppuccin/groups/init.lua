-- tokyoppuccin — collect all highlight groups from palette + config.
-- editor shell + syntax cover the theme. The base groups (Pmenu, StatusLine,
-- GitSigns, Search…) already carry telescope/cmp/lualine/gitsigns, so dedicated
-- plugin files under groups/plugins/ are optional — loaded only if non-empty.

local M = {}

function M.get(c, opts)
  local groups = {}
  local function merge(t)
    for k, v in pairs(t) do
      groups[k] = v
    end
  end

  merge(require("tokyoppuccin.groups.editor")(c, opts))
  merge(require("tokyoppuccin.groups.syntax")(c, opts))

  return groups
end

return M
