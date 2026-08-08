-- lualine theme for tokyoppuccin-storm.
-- Auto-resolved by lualine's `theme = "auto"` via vim.g.colors_name, so LazyVim
-- picks it up with no extra config. Mode-colored `a` sections (normal=blue,
-- insert=green, …); b/c inherit from `normal` when a mode omits them.

local c = require("tokyoppuccin.palette").storm

local function mode(accent)
	return { a = { fg = c.bg, bg = accent, gui = "bold" } }
end

local normal = {
	a = { fg = c.bg, bg = c.variable, gui = "bold" }, -- NORMAL badge = cyan, matches picker borders
	b = { fg = c.variable, bg = c.bg_active },
	c = { fg = c.fg_editor, bg = c.bg },
}

return {
	normal = normal,
	insert = mode(c.green),
	visual = mode(c.mauve),
	replace = mode(c.red),
	command = mode(c.yellow),
	terminal = mode(c.teal),
	inactive = {
		a = { fg = c.fg_muted, bg = c.bg },
		b = { fg = c.fg_muted, bg = c.bg },
		c = { fg = c.fg_muted, bg = c.bg },
	},
}
