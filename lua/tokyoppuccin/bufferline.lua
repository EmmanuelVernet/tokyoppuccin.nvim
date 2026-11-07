-- tokyoppuccin — bufferline.nvim highlights.
--
-- NOT part of the colorscheme's highlight table: bufferline re-derives every
-- BufferLine* group from Normal on its own ColorScheme autocmd, so anything the
-- theme sets is clobbered a moment later. The only override that survives is
-- the `highlights` key of bufferline's own setup:
--
--   opts = { highlights = function() return require("tokyoppuccin.bufferline").get() end }
--
-- Pass the function, not its result: bufferline re-calls it on ColorScheme, so
-- the tabs follow a terminal bg change under `transparent`.
--
-- Ramp follows Zed's tab bar, not bufferline's default shading (which darkens
-- Normal by -45 and turns the empty strip into a black void):
--   tab bar #232634 < inactive #1d202b < visible #292c3c < active #303446

local M = {}

function M.get(style)
	local c, opts = require("tokyoppuccin.theme").colors(style and { style = style })
	-- transparent: the strip and inactive tabs let the terminal bg through; the
	-- visible/selected pills keep a fill (re-mixed over the terminal bg) so the
	-- current buffer still reads.
	local clear = opts.transparent and "NONE" or c.bg
	local bar, off, vis, sel = clear, clear, c.surface, c.bg_active

	local hl = {
		fill = { fg = c.comment, bg = bar },
		background = { fg = c.fg_muted, bg = off },
		buffer = { fg = c.fg_muted, bg = off },
		buffer_visible = { fg = c.fg_editor, bg = vis },
		buffer_selected = { fg = c.fg, bg = sel, bold = true },

		indicator_visible = { fg = vis, bg = vis },
		indicator_selected = { fg = c.blue, bg = sel },
		tab = { fg = c.fg_muted, bg = off },
		tab_selected = { fg = c.fg, bg = sel },
		tab_separator = { fg = c.bg, bg = off },
		tab_separator_selected = { fg = c.bg, bg = sel },
		tab_close = { fg = c.red, bg = bar },
		offset_separator = { fg = c.border, bg = bar },
		trunc_marker = { fg = c.comment, bg = bar },
		group_separator = { fg = c.comment, bg = bar },
		group_label = { fg = c.bg, bg = c.comment },
	}

	-- Every group that sits *on* a tab has to carry that tab's background, or the
	-- close button / count / diagnostic icon punches a hole in it.
	local bgs = { off, vis, sel }
	local states = { "", "_visible", "_selected" }
	local families = {
		close_button = { c.fg_muted, c.fg_editor, c.fg },
		numbers = { c.fg_muted, c.fg_editor, c.fg },
		modified = { c.yellow, c.yellow, c.yellow },
		duplicate = { c.comment, c.fg_muted, c.fg_muted },
		diagnostic = { c.fg_muted, c.fg_muted, c.fg_editor },
		error = { c.red, c.red, c.red },
		warning = { c.yellow, c.yellow, c.yellow },
		info = { c.diag_info, c.diag_info, c.diag_info },
		hint = { c.hint, c.hint, c.hint },
		error_diagnostic = { c.red, c.red, c.red },
		warning_diagnostic = { c.yellow, c.yellow, c.yellow },
		info_diagnostic = { c.diag_info, c.diag_info, c.diag_info },
		hint_diagnostic = { c.hint, c.hint, c.hint },
		separator = { c.bg, c.bg, c.bg },
	}
	for name, fgs in pairs(families) do
		for i, state in ipairs(states) do
			hl[name .. state] = { fg = fgs[i], bg = bgs[i] }
		end
	end
	for i, state in ipairs(states) do
		hl["pick" .. state] = { fg = c.red, bg = bgs[i], bold = true }
	end

	return hl
end

return M
