-- tokyoppuccin — config defaults + user merge

local M = {}

M.defaults = {
  style = "storm", -- only variant for now; loader is keyed on style
  transparent = false, -- clear Normal / NormalFloat / SignColumn backgrounds
  terminal_colors = true, -- set vim.g.terminal_color_*
  styles = {
    comments = { italic = true },
    keywords = {},
    functions = {},
    variables = { italic = true },
  },
  on_colors = function(_) end, -- mutate palette before groups build
  on_highlights = function(_, _) end, -- final override hook
}

M.options = nil

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

-- Return current options, optionally overlaid with a one-off table (for load(style)).
function M.extend(opts)
  local base = M.options or M.defaults
  return opts and vim.tbl_deep_extend("force", base, opts) or base
end

return M
