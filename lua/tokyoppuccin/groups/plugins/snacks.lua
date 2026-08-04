-- snacks.nvim.
-- Part 1 is a 1:1 port of tokyonight's groups/snacks.lua (notifier, dashboard,
-- profiler, indent, input, picker accents), palette-mapped: blue1->cyan,
-- magenta2->hotpink, dark3->placeholder, fg_gutter/blue7->line_nr, info->diag_info.
-- Part 2 is BEYOND tokyonight: explorer sidebar bg / names / git status, added
-- because the flat sidebar + grey files were the specific gripes. Drop part 2 if
-- you ever want pure tokyonight parity.

local util = require("tokyoppuccin.util")

return function(c, opts)
  local bg = opts.transparent and "NONE" or c.bg
  local dark = opts.transparent and "NONE" or c.bg -- picker panels match editor bg
  local blend = function(fg, a) return util.blend_bg(c, fg, a) end

  -- rainbow indent (tokyonight iterates c.rainbow); accents in warm->cool order
  local rainbow = { c.red, c.orange, c.yellow, c.green, c.teal, c.blue, c.purple, c.mauve }

  local groups = {
    ---------------------------------------------------------------- tokyonight port
    -- Notifier
    SnacksNotifierDebug       = { fg = c.fg, bg = bg },
    SnacksNotifierBorderDebug = { fg = blend(c.comment, 0.4), bg = bg },
    SnacksNotifierIconDebug   = { fg = c.comment },
    SnacksNotifierTitleDebug  = { fg = c.comment },
    SnacksNotifierError       = { fg = c.fg, bg = bg },
    SnacksNotifierBorderError = { fg = blend(c.red, 0.4), bg = bg },
    SnacksNotifierIconError   = { fg = c.red },
    SnacksNotifierTitleError  = { fg = c.red },
    SnacksNotifierInfo        = { fg = c.fg, bg = bg },
    SnacksNotifierBorderInfo  = { fg = blend(c.diag_info, 0.4), bg = bg },
    SnacksNotifierIconInfo    = { fg = c.diag_info },
    SnacksNotifierTitleInfo   = { fg = c.diag_info },
    SnacksNotifierTrace       = { fg = c.fg, bg = bg },
    SnacksNotifierBorderTrace = { fg = blend(c.purple, 0.4), bg = bg },
    SnacksNotifierIconTrace   = { fg = c.purple },
    SnacksNotifierTitleTrace  = { fg = c.purple },
    SnacksNotifierWarn        = { fg = c.fg, bg = bg },
    SnacksNotifierBorderWarn  = { fg = blend(c.yellow, 0.4), bg = bg },
    SnacksNotifierIconWarn    = { fg = c.yellow },
    SnacksNotifierTitleWarn   = { fg = c.yellow },
    -- Dashboard. Diverges from tokyonight: its Desc=cyan / Icon+Footer=blue1 both
    -- landed on c.cyan here (the blue1->cyan mapping), flattening three roles into
    -- one punctuation-grade tone. Desc goes pink (same "act here" sense as
    -- SnacksPickerPrompt, and magenta-side so it doesn't muddy the orange keys),
    -- icons take the border_accent already used for picker titles.
    SnacksDashboardDesc    = { fg = c.pink },
    SnacksDashboardFooter  = { fg = c.border_accent },
    SnacksDashboardHeader  = { fg = c.blue },
    SnacksDashboardIcon    = { fg = c.border_accent },
    SnacksDashboardKey     = { fg = c.orange },
    SnacksDashboardSpecial = { fg = c.purple },
    SnacksDashboardDir     = { fg = c.placeholder },
    -- Profiler
    SnacksProfilerIconInfo   = { bg = blend(c.cyan, 0.3), fg = c.cyan },
    SnacksProfilerBadgeInfo  = { bg = blend(c.cyan, 0.1), fg = c.cyan },
    SnacksFooterKey          = "SnacksProfilerIconInfo",
    SnacksFooterDesc         = "SnacksProfilerBadgeInfo",
    SnacksProfilerIconTrace  = { bg = blend(c.line_nr, 0.3), fg = c.placeholder },
    SnacksProfilerBadgeTrace = { bg = blend(c.line_nr, 0.1), fg = c.placeholder },
    -- Indent
    SnacksIndent      = { fg = c.line_nr, nocombine = true },
    SnacksIndentScope = { fg = c.cyan, nocombine = true },
    -- Input / zen
    SnacksZenIcon     = { fg = c.purple },
    SnacksInputIcon   = { fg = c.cyan },
    SnacksInputBorder = { fg = c.yellow },
    SnacksInputTitle  = { fg = c.yellow },
    -- Picker accents
    SnacksPickerInputBorder    = { fg = c.border_accent, bg = dark },
    SnacksPickerInputTitle     = { fg = c.border_accent, bg = dark },
    SnacksPickerBoxTitle       = { fg = c.border_accent, bg = dark },
    SnacksPickerSelected       = { fg = c.hotpink },
    SnacksPickerToggle         = "SnacksProfilerBadgeInfo",
    SnacksPickerPickWinCurrent = { fg = c.fg, bg = c.hotpink, bold = true },
    SnacksPickerPickWin        = { fg = c.fg, bg = c.search, bold = true },
    SnacksGhLabel              = { fg = c.cyan, bold = true },
    SnacksDiffLabel            = { fg = c.cyan, bold = true },
    SnacksGhDiffHeader         = { bg = blend(c.cyan, 0.1), fg = c.cyan },

    ---------------------------------------------------------------- explorer extras
    -- Sidebar panel darker than the editor (window Normal resolves to these).
    SnacksPicker              = { bg = dark },
    SnacksPickerList          = { bg = dark },
    SnacksPickerInput         = { bg = dark },
    SnacksPickerBox           = { bg = dark },
    SnacksPickerPreview       = { bg = bg },
    SnacksPickerBorder        = { fg = c.border_accent, bg = dark },
    SnacksPickerListBorder    = { fg = c.border_accent, bg = dark },
    SnacksPickerBoxBorder     = { fg = c.border_accent, bg = dark },
    SnacksPickerPreviewBorder = { fg = c.border_accent, bg = bg },
    SnacksPickerListCursorLine    = { bg = c.bg_active },
    SnacksPickerPreviewCursorLine = { bg = c.cursor_line },
    SnacksPickerTitle         = { fg = c.border_accent, bg = dark, bold = true },
    SnacksPickerPrompt        = { fg = c.pink },
    -- Names
    SnacksPickerFile        = { fg = c.fg },
    SnacksPickerDir         = { fg = c.fg_muted },
    SnacksPickerDirectory   = { fg = c.blue },
    SnacksPickerPathHidden  = { fg = c.disabled },
    SnacksPickerPathIgnored = { fg = c.disabled },
    SnacksPickerTree        = { fg = c.line_nr },
    -- Git status (untracked/ignored were NonText grey)
    SnacksPickerGitStatusUntracked = { fg = c.teal },
    SnacksPickerGitStatusIgnored   = { fg = c.disabled },
    SnacksPickerGitStatusAdded     = { fg = c.green },
    SnacksPickerGitStatusModified  = { fg = c.yellow },
    SnacksPickerGitStatusDeleted   = { fg = c.red },
    SnacksPickerGitStatusRenamed   = { fg = c.orange },
    SnacksPickerGitStatusStaged    = { fg = c.teal },
  }

  for i, color in ipairs(rainbow) do
    groups["SnacksIndent" .. i] = { fg = color, nocombine = true }
  end

  return groups
end
