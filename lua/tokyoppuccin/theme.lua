-- tokyoppuccin — assemble the full highlight table from palette + config.
-- Applies on_colors (palette mutation) and on_highlights (final override).

local M = {}

-- Returns groups, colors, opts. Does NOT touch the editor — init.load() applies.
function M.build(opts)
  opts = require("tokyoppuccin.config").extend(opts)

  local c = require("tokyoppuccin.palette").get(opts.style)
  opts.on_colors(c)

  local groups = require("tokyoppuccin.groups").get(c, opts)
  opts.on_highlights(groups, c)

  return groups, c, opts
end

return M
