-- snacks.nvim — picker / explorer / indent polish.
-- Snacks sets its own `default=true` links (SnacksPickerDir -> Directory, …) so the
-- explorer is already functional; these are the accents tokyonight overrides for
-- the tuned look. Explicit (non-default) hls win over snacks' defaults on ColorScheme.
-- tokyonight roles mapped to the tokyoppuccin palette (blue1->cyan, magenta2->hotpink).

return function(c, opts)
  return {
    -- Indent guides in the explorer tree
    SnacksIndent      = { fg = c.line_nr, nocombine = true },
    SnacksIndentScope = { fg = c.cyan, nocombine = true },

    -- Picker / explorer window
    SnacksPickerDir        = { fg = c.fg_muted },
    SnacksPickerPathHidden = { fg = c.disabled },
    SnacksPickerTitle      = { fg = c.orange },
    SnacksPickerSelected   = { fg = c.hotpink },
    SnacksPickerInputBorder = { fg = c.orange, bg = c.bg },
    SnacksPickerInputTitle  = { fg = c.orange, bg = c.bg },
    SnacksPickerBoxTitle    = { fg = c.orange, bg = c.bg },
    SnacksPickerPickWinCurrent = { fg = c.fg, bg = c.hotpink, bold = true },
    SnacksPickerPickWin        = { fg = c.fg, bg = c.search, bold = true },

    -- Input box
    SnacksInputIcon   = { fg = c.cyan },
    SnacksInputBorder = { fg = c.yellow },
    SnacksInputTitle  = { fg = c.yellow },
  }
end
