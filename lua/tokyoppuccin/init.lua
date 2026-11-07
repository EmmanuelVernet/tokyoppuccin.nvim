-- tokyoppuccin.nvim — public API
--   require("tokyoppuccin").setup({ ... })  -- store options
--   require("tokyoppuccin").load("storm")   -- apply the colorscheme
-- colors/tokyoppuccin-storm.lua calls load() so :colorscheme + lazy managers work.

local M = {}

-- extras/ holds queries/<lang>/<name>.scm and is kept off the runtimepath, so
-- those `;; extends` overrides only reach treesitter when ruby_queries is on.
-- Appended (not prepended) so they extend the parser's query rather than
-- replace it.
--
-- Must be reversible: the runtimepath outlives the colorscheme, so leaving the
-- entry behind means another theme inherits our parser captures. set_queries is
-- idempotent and ColorSchemePre tears it down on the way out.
local function extras_dir()
  local init = vim.api.nvim_get_runtime_file("lua/tokyoppuccin/init.lua", false)[1]
  return init and (init:gsub("lua/tokyoppuccin/init%.lua$", "extras"))
end

local function set_queries(on)
  local dir = extras_dir()
  if not dir then return end
  if on == vim.tbl_contains(vim.opt.rtp:get(), dir) then return end

  if on then vim.opt.rtp:append(dir) else vim.opt.rtp:remove(dir) end

  -- query.get is memoized, so the rtp change alone changes nothing.
  vim.treesitter.query.get:clear("ruby", "highlights")

  -- Live buffers hold an already-parsed query; restart them so this lands now
  -- rather than on next open.
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].filetype == "ruby" and vim.treesitter.highlighter.active[buf] then
      pcall(vim.treesitter.stop, buf)
      pcall(vim.treesitter.start, buf, "ruby")
    end
  end
end

-- Drop the overrides when a non-tokyoppuccin colorscheme takes over.
vim.api.nvim_create_autocmd("ColorSchemePre", {
  group = vim.api.nvim_create_augroup("TokyoppuccinQueries", { clear = true }),
  callback = function(ev)
    if not vim.startswith(ev.match or "", "tokyoppuccin") then
      set_queries(false)
    end
  end,
})

-- transparent: theme.build re-bakes cursor_line over the terminal's real bg, so
-- track it from OSC 11 replies. nvim's own startup query is answered before user
-- config loads, so ask again on every load and when focus returns (switching the
-- terminal's theme usually takes focus off the pane). Reload only on change, so
-- the load -> query -> reply round trip can't loop.
local function parse_osc11(seq)
  local r, g, b = seq:match("^\027%]11;rgba?:(%x+)/(%x+)/(%x+)")
  if not r then return end
  local ch = function(h) return math.floor(tonumber(h, 16) / (16 ^ #h - 1) * 255 + 0.5) end
  return string.format("#%02x%02x%02x", ch(r), ch(g), ch(b))
end

local function query_term_bg()
  if require("tokyoppuccin.config").extend().transparent then
    vim.api.nvim_ui_send("\027]11;?\007")
  end
end

local term_bg_group = vim.api.nvim_create_augroup("TokyoppuccinTermBg", { clear = true })
vim.api.nvim_create_autocmd("TermResponse", {
  group = term_bg_group,
  nested = true, -- let lualine/bufferline see the ColorScheme reload
  callback = function(ev)
    local bg = parse_osc11(ev.data.sequence)
    if not bg or bg == vim.g.tokyoppuccin_term_bg then return end
    vim.g.tokyoppuccin_term_bg = bg
    if vim.startswith(vim.g.colors_name or "", "tokyoppuccin") then
      vim.cmd.colorscheme(vim.g.colors_name)
    end
  end,
})
vim.api.nvim_create_autocmd("FocusGained", { group = term_bg_group, callback = query_term_bg })

function M.setup(opts)
  require("tokyoppuccin.config").setup(opts)
end

function M.load(style)
  local groups, c, opts = require("tokyoppuccin.theme").build(style and { style = style } or nil)

  set_queries(opts.ruby_queries)

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

  query_term_bg()
end

return M
