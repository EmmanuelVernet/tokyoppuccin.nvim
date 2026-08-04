-- mini.icons — https://github.com/echasnovski/mini.icons
-- 1:1 port of tokyonight's groups/mini_icons.lua, palette-mapped: info->diag_info.
-- Needed because mini.icons' own defaults (default = true, so they only apply when
-- the theme is silent) link Cyan->DiagnosticHint (grey), Orange->DiagnosticWarn
-- (same yellow as Yellow) and Purple->Constant. Icons went grey/washed without this.

return function(c, opts)
  -- stylua: ignore
  return {
    MiniIconsGrey   = { fg = c.fg },
    MiniIconsPurple = { fg = c.purple },
    MiniIconsBlue   = { fg = c.blue },
    MiniIconsAzure  = { fg = c.diag_info },
    MiniIconsCyan   = { fg = c.teal },
    MiniIconsGreen  = { fg = c.green },
    MiniIconsYellow = { fg = c.yellow },
    MiniIconsOrange = { fg = c.orange },
    MiniIconsRed    = { fg = c.red },
  }
end
