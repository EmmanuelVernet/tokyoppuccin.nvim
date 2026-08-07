-- lualine theme alias, so `theme = "tokyoppuccin"` resolves the same as the
-- suffixed name. lualine's `theme = "auto"` uses vim.g.colors_name, which is
-- always tokyoppuccin-<style>, so this exists for explicit config only.
return require("lualine.themes.tokyoppuccin-storm")
