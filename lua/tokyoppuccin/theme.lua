-- tokyoppuccin — assemble the full highlight table from palette + config.
-- Applies on_colors (palette mutation) and on_highlights (final override).

local M = {}

-- UI fills baked over the storm bg, keyed by the ink each was mixed from
-- ("fg" = lighter-than-bg neutral). Under transparent, init.lua reads the
-- terminal's real bg from its OSC 11 reply and these are re-mixed over it, at
-- the alpha recovered from the storm bake. On a light bg the "fg" neutrals mix
-- in dark instead, or they'd vanish into white.
local overlays = {
  surface = "fg", -- Pmenu, Folded, ColorColumn, bufferline visible tab
  bg_active = "fg", -- PmenuSel, lualine b, bufferline selected tab, picker cursor
  element_hover = "fg",
  cursor_line = "fg",
  bg_dark = "#000000",
  element = "#000000",
  wrap_guide = "#000000",
  border = "#000000",
  visual = "#949cbb", -- Zed players[0].selection
  search = "teal", -- Zed search.match_background
}

-- Palette for `opts` (style, transparent, on_colors), re-mixed over the
-- terminal bg when transparent. Shared by build, bufferline and lualine so the
-- bars and popups match the editor.
function M.colors(opts)
  opts = require("tokyoppuccin.config").extend(opts)

  local c = require("tokyoppuccin.palette").get(opts.style)
  local term_bg = opts.transparent and vim.g.tokyoppuccin_term_bg
  if term_bg then
    local util = require("tokyoppuccin.util")
    c.term_bg = term_bg -- blend_bg tints (snacks badges, notifier borders) mix over it
    local light = util.is_light(term_bg)
    for key, ink in pairs(overlays) do
      ink = c[ink] or ink
      local alpha = util.unblend(c[key], ink, c.bg)
      c[key] = util.blend((light and ink == c.fg) and c.bg or ink, alpha, term_bg)
    end
  end
  opts.on_colors(c)

  return c, opts
end

-- Returns groups, colors, opts. Does NOT touch the editor — init.load() applies.
function M.build(opts)
  local c
  c, opts = M.colors(opts)

  local groups = require("tokyoppuccin.groups").get(c, opts)
  opts.on_highlights(groups, c)

  return groups, c, opts
end

return M
