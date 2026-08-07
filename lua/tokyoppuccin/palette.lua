-- tokyoppuccin — palette (single source of truth)
-- Ported 1:1 from the Zed theme "Tokyoppuccin Storm".
-- Keyed by style so future variants are just another table.

local M = {}

M.storm = {
  -- Surfaces
  bg             = "#24283b", -- background / editor.background
  bg_dark        = "#1d202b", -- tab.inactive_background
  surface        = "#292c3c", -- surface.background
  bg_active      = "#303446", -- tab.active_background
  element        = "#232634", -- element.background / tab_bar
  element_hover  = "#414559", -- element.hover
  wrap_guide     = "#1b1e2e", -- editor.wrap_guide

  -- Foregrounds
  fg             = "#c6d0f5", -- text (syntax) / terminal.foreground / icon
  fg_editor      = "#a9b1d6", -- editor.foreground / text / active_line_number
  fg_muted       = "#7982a9", -- text.muted
  placeholder    = "#626880", -- text.placeholder / hint
  disabled       = "#51576d", -- text.disabled
  comment        = "#565f89", -- comment
  comment_doc    = "#949cbb", -- comment.doc / comment.documentation
  hint           = "#838ba7", -- syntax hint / icon.muted

  -- Chrome
  border         = "#212538", -- border / pane_group.border
  border_accent  = "#0db9d7", -- colored border + picker titles = vivid cyan; swap to taste
  line_nr        = "#474f75", -- editor.line_number

  -- Accents / syntax
  red            = "#e78284", -- variable.builtin, error, deleted, variant
  orange         = "#ef9f76", -- constant(.builtin), number(.float), boolean, attribute,
                              -- function.builtin, string.regexp, conflict, parent, decorator
  yellow         = "#e5c890", -- module, namespace, type.definition, type.interface,
                              -- tag.attribute, warning, modified
  yellow2        = "#e0af68", -- type, type.super (tokyonight yellow)
  green          = "#a6d189", -- string, text.literal, created, diff.plus
  teal           = "#81c8be", -- character, string.doc(umentation), function.macro,
                              -- tag.delimiter, info, enum
  teal_var       = "#46c4bb", -- variable.special
  blue           = "#7aa2f7", -- function(.call/.method), property
  blue2          = "#8caaee", -- variable.member, tag, link_uri, comment.hint
  variable       = "#0db9d7", -- variable
  declaration    = "#5ed2ff", -- ruby's declarative macros: attr_reader/_writer/_accessor,
                              -- module_function, include/extend/prepend/refine/using.
                              -- Same hue as `variable`, +24 lightness, so they read as
                              -- language machinery rather than as values (orange).
  cyan           = "#7dcfff", -- punctuation(.delimiter/.bracket/.list_marker) — tokyonight cyan
  cyan2          = "#89ddff", -- operator, keyword.export, link_text.hover — tokyonight blue5
  purple         = "#bb9af7", -- keyword, keyword.function
  mauve          = "#ca9ee6", -- constant.macro, type.builtin, tag.doctype, accent
  hotpink        = "#ff8bcb", -- keyword.modifier/type/coroutine/operator/import/repeat/
                              -- return/debug/exception/conditional/directive
  pink           = "#f4b8e4", -- string.escape, string.special, punctuation.special,
                              -- character.special, symbol
  rosewater      = "#f2d5cf", -- string.special.url, comment.note
  constructor    = "#eebebe", -- constructor, comment.todo, punctuation.special.symbol
  label          = "#85c1dc", -- label, concept, renamed
  field          = "#babbf1", -- field, link_text
  salmon         = "#ea999c", -- parameter, emphasis, primary, embedded
  symbol_red     = "#e8a9a9", -- string.special.symbol

  -- Selections (approximated from Zed's alpha-blended colors over the editor bg)
  visual         = "#40455b", -- players[0].selection #949cbb40 over bg
  search         = "#374855", -- search.match_background #81c8be33 over bg
  cursor_line    = "#282c40", -- editor.active_line.background #c6d0f512 over bg

  -- Diagnostics INFO: tokyonight's "original teal" (#0db9d7), bluer than Zed's
  -- greener info #81c8be. Used only for INFO-severity diagnostics (e.g. RuboCop
  -- Style/* offenses) so they read as teal, not green.
  diag_info      = "#0db9d7",

  -- Diff backgrounds (dimmed accent over bg)
  diff_add_bg    = "#2c3a2e",
  diff_change_bg = "#3a3626",
  diff_delete_bg = "#3a2a2c",
  diff_text_bg   = "#4a4530",

  -- Terminal ANSI (Zed terminal.ansi.*)
  terminal = {
    "#51576d", "#e78284", "#a6d189", "#e5c890",
    "#8caaee", "#f4b8e4", "#81c8be", "#a5adce",
    "#626880", "#e67172", "#8ec772", "#d9ba73",
    "#7b9ef0", "#f4b8e4", "#5abfb5", "#b5bfe2",
  },
}

function M.get(style)
  return vim.deepcopy(M[style] or M.storm)
end

return M
