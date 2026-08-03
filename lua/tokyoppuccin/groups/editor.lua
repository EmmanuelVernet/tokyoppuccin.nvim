-- tokyoppuccin — editor / UI shell
-- The "shell" tokyonight would own: Normal, floats, menus, statusline, tabs,
-- diagnostics, diff/VCS, git signs. Standalone (no tokyonight dependency).

return function(c, opts)
  -- transparent: drop the editor/float/sign backgrounds so the terminal shows through
  local bg = opts.transparent and "NONE" or c.bg

  return {
    -- Editor / UI
    Normal       = { fg = c.fg_editor, bg = bg },
    NormalFloat  = { fg = c.fg_editor, bg = bg },
    FloatBorder  = { fg = c.border_accent, bg = bg },
    FloatTitle   = { fg = c.fg, bold = true },
    Cursor       = { fg = c.bg, bg = c.rosewater }, -- vim.normal.background
    CursorLine   = { bg = c.cursor_line },
    CursorColumn = { bg = c.cursor_line },
    CursorLineNr = { fg = c.fg_editor, bold = true },
    LineNr       = { fg = c.line_nr },
    SignColumn   = { bg = bg },
    FoldColumn   = { fg = c.line_nr, bg = bg },
    Folded       = { fg = c.fg_muted, bg = c.surface },
    ColorColumn  = { bg = c.surface },
    VertSplit    = { fg = c.border_accent },
    WinSeparator = { fg = c.border_accent },
    Pmenu        = { fg = c.fg_editor, bg = c.surface },
    PmenuSel     = { fg = c.fg, bg = c.bg_active },
    PmenuSbar    = { bg = c.surface },
    PmenuThumb   = { bg = c.placeholder },
    Visual       = { bg = c.visual },
    Search       = { bg = c.search },
    IncSearch    = { fg = c.bg, bg = c.mauve },
    CurSearch    = { fg = c.bg, bg = c.mauve },
    MatchParen   = { fg = c.mauve, bold = true },
    Directory    = { fg = c.blue },
    Title        = { fg = c.fg, bold = true },
    NonText      = { fg = c.disabled },
    Whitespace   = { fg = c.disabled },
    SpecialKey   = { fg = c.disabled },
    Conceal      = { fg = c.fg_muted },
    EndOfBuffer  = { fg = bg == "NONE" and c.bg or bg },
    StatusLine   = { fg = c.fg_editor, bg = c.bg },
    StatusLineNC = { fg = c.fg_muted, bg = c.bg },
    TabLine      = { fg = c.fg_muted, bg = c.element },
    TabLineFill  = { bg = c.element },
    TabLineSel   = { fg = c.fg, bg = c.bg_active },
    WinBar       = { fg = c.fg_editor, bg = bg },
    WinBarNC     = { fg = c.fg_muted, bg = bg },

    -- Diagnostics (Zed severities: error red, warn yellow, info teal, hint hint)
    DiagnosticError = { fg = c.red },
    DiagnosticWarn  = { fg = c.yellow },
    DiagnosticInfo  = { fg = c.diag_info },
    DiagnosticHint  = { fg = c.hint },
    DiagnosticOk    = { fg = c.green },
    DiagnosticUnderlineError = { undercurl = true, sp = c.red },
    DiagnosticUnderlineWarn  = { undercurl = true, sp = c.yellow },
    DiagnosticUnderlineInfo  = { undercurl = true, sp = c.diag_info },
    DiagnosticUnderlineHint  = { undercurl = true, sp = c.hint },
    DiagnosticVirtualTextError = { fg = c.red },
    DiagnosticVirtualTextWarn  = { fg = c.yellow },
    DiagnosticVirtualTextInfo  = { fg = c.diag_info },
    DiagnosticVirtualTextHint  = { fg = c.hint },
    DiagnosticVirtualTextOk    = { fg = c.green },
    DiagnosticSignError = { fg = c.red },
    DiagnosticSignWarn  = { fg = c.yellow },
    DiagnosticSignInfo  = { fg = c.diag_info },
    DiagnosticSignHint  = { fg = c.hint },
    DiagnosticSignOk    = { fg = c.green },
    DiagnosticFloatingError = { fg = c.red },
    DiagnosticFloatingWarn  = { fg = c.yellow },
    DiagnosticFloatingInfo  = { fg = c.diag_info },
    DiagnosticFloatingHint  = { fg = c.hint },
    DiagnosticFloatingOk    = { fg = c.green },

    -- Diff / VCS
    DiffAdd    = { fg = c.green,  bg = c.diff_add_bg },
    DiffChange = { fg = c.yellow, bg = c.diff_change_bg },
    DiffDelete = { fg = c.red,    bg = c.diff_delete_bg },
    DiffText   = { fg = c.yellow, bg = c.diff_text_bg },
    Added      = { fg = c.green },
    Changed    = { fg = c.yellow },
    Removed    = { fg = c.red },

    -- Git signs (gitsigns.nvim; base groups other git plugins inherit too)
    GitSignsAdd    = { fg = c.green },
    GitSignsChange = { fg = c.yellow },
    GitSignsDelete = { fg = c.red },
  }
end
