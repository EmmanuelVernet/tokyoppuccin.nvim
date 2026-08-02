-- tokyoppuccin.nvim — public API
--   require("tokyoppuccin").setup({ ... })  -- store options
--   require("tokyoppuccin").load("storm")   -- apply the colorscheme
-- colors/tokyoppuccin-storm.lua calls load() so :colorscheme + lazy managers work.

local M = {}

function M.setup(opts)
  require("tokyoppuccin.config").setup(opts)
end

function M.load(style)
  local groups, c, opts = require("tokyoppuccin.theme").build(style and { style = style } or nil)

  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.g.colors_name = "tokyoppuccin-" .. opts.style

  local set = vim.api.nvim_set_hl
  for group, spec in pairs(groups) do
    -- allow tokyonight-style string values as links ("Foo" == { link = "Foo" })
    set(0, group, type(spec) == "string" and { link = spec } or spec)
  end

  if opts.terminal_colors then
    for i, hex in ipairs(c.terminal) do
      vim.g["terminal_color_" .. (i - 1)] = hex
    end
  end
end

return M
