# tokyoppuccin.nvim

A Neovim colorscheme ported 1:1 from the Zed theme **Tokyoppuccin Storm** — a
Catppuccin-flavored take on Tokyo Night Storm.

> **Status: working, not yet distributable.** The theme is built and in daily use.
> This README is the working notes: what exists, what's known-broken, and what
> blocks handing it to other developers. Rewrite it as user-facing docs (install,
> config, screenshots) once the backlog below is cleared.

## Install

```lua
{ "EmmanuelVernet/tokyoppuccin.nvim", lazy = false, priority = 1000 }
```

```vim
:colorscheme tokyoppuccin-storm
```

Note the `-storm` suffix is currently **required** — see backlog item 9.

## Current state

```
colors/tokyoppuccin-storm.lua      -- thin entry point -> require("tokyoppuccin").load("storm")
lua/tokyoppuccin/
├── init.lua                       -- setup(opts) + load(style); hi clear, apply, terminal colors
├── config.lua                     -- defaults + vim.tbl_deep_extend user merge
├── palette.lua                    -- THE color table, keyed by style
├── theme.lua                      -- build(opts) -> groups, colors, opts
├── util.lua                       -- blend helpers
└── groups/
    ├── init.lua                   -- editor + syntax + plugins
    ├── editor.lua                 -- UI shell, diagnostics, diff, git signs
    ├── syntax.lua                 -- legacy syntax + @treesitter + @lsp (single copy)
    └── plugins/
        ├── init.lua               -- dumb `enabled` list, no auto-detect machinery
        ├── mini_icons.lua
        └── snacks.lua             -- notifier, dashboard, profiler, indent, input, picker, explorer
lua/lualine/themes/tokyoppuccin-storm.lua
after/queries/ruby/highlights.scm
```

Storm is the only variant. The loader is keyed on `style`, so adding one is just
another palette table.

## Config API

```lua
require("tokyoppuccin").setup({
  style = "storm",
  transparent = false,      -- clear Normal/NormalFloat/SignColumn backgrounds
  terminal_colors = true,   -- set vim.g.terminal_color_*
  styles = {
    comments = { italic = true },
    keywords = {},
    functions = {},
    variables = { italic = true },
  },
  on_colors = function(colors) end,         -- mutate palette before groups build
  on_highlights = function(hl, colors) end, -- final override hook
})
```

There is no `plugins = { all, auto }` option — `groups/plugins/init.lua` is a
hand-maintained `enabled` list on purpose. Add a file, add its name.

## Port notes worth preserving

Decisions that are not derivable from the code. Match the **rendered** Zed color,
not the theme-JSON scope name.

- `this`/`super`/`self` render **teal** (`#46c4bb`, `variable.special`), not the
  red the theme JSON lists for `variable.builtin`.
- The whole `keyword` family is **purple**; only import / exception / directive
  get the **hotpink** accent.
- Ruby instance/class vars (`@foo`, `@@foo`) arrive as `@variable.member` but must
  stay **teal** — scoped per-language via `@variable.member.ruby`.
- RuboCop `Style/*` offenses arrive at INFO severity → bluer teal
  (`diag_info = #0db9d7`), distinct from Zed's greener info `#81c8be`.
- `@lsp.type.class`/`namespace` link to `@type` so CamelCase decls and refs match.
- `@lsp.type.method.ruby` is cleared so bare calls keep treesitter `@variable`
  (teal) while explicit `.method` calls stay `@function.method.call` (blue).
- `snacks.lua` part 2 (explorer sidebar bg / names / git status) is **beyond**
  tokyonight parity — added because the flat sidebar and grey filenames were the
  specific gripes. Drop it for pure parity.

---

# Backlog

Findings from a full audit, ranked by how often a user would see them.

## Tier 1 — visible daily

### 1. Completion menu is monochrome

`blink.cmp`'s `BlinkCmpKind*` groups link `PmenuKind` → `Pmenu`
(`blink/cmp/highlights.lua:21-24`), so every kind icon — function, variable,
class, snippet — renders one flat `fg_editor`. Same root cause flattens
`BlinkCmpLabelDetail` / `Description` / `Source` via `PmenuExtra`.

Fix: a `groups/kinds.lua` in the mold of tokyonight's, generating per-kind colors
and feeding cmp/blink (and later navic/aerial/trouble). Biggest single looks win
available.

### 2. `PmenuSel` is effectively invisible

`groups/editor.lua:26-27`:

```lua
Pmenu    = { fg = c.fg_editor, bg = c.surface },   -- #292c3c
PmenuSel = { fg = c.fg, bg = c.bg_active },        -- #303446
```

Contrast ratio **1.13:1** — you cannot tell which completion row is selected.
`element_hover #414559` gives 1.45:1 and is currently an *unused* palette entry
whose documented Zed role is exactly this (`element.hover`). Add `bold` too.

### 3. Message and prompt colors are Neovim's, not the theme's

After `hi clear`, Neovim 0.10+'s default colorscheme backfills every group the
theme doesn't set. Currently leaking through:

| Group | Renders as | Should be |
| --- | --- | --- |
| `ErrorMsg` | `#FFC0B9` NvimLightRed | `c.red #e78284` |
| `WarningMsg` | `#FCE094` NvimLightYellow | `c.yellow #e5c890` |
| `ModeMsg` | `#B3F6C0` NvimLightGreen | `c.green` |
| `MoreMsg`, `Question` | `#8CF8F7` neon cyan | `c.diag_info` |
| `QuickFixLine` | `#8CF8F7`, fg-only | needs a **bg** |
| `SpellBad` / `Cap` / `Local` / `Rare` | Neovim `sp` colors | theme severities |
| `DiagnosticDeprecated` | Neovim red `sp` | `c.red` |

`QuickFixLine` is the worst: fg-only means no selected-row background in quickfix
*or* Trouble, and that cyan appears nowhere in the palette.

### 4. Markdown headings are flat

`groups/syntax.lua:145` sets `@markup.heading` = `c.fg` bold and nothing for
`.1`–`.6`, so every heading level looks identical. Also unset: `Bold`, `Italic`,
`@markup.quote`, `@markup.math`.

Worth doing before the user-facing README rewrite — that work happens in markdown.

## Tier 2 — dead code and self-contradictions

### 5. Five 0-byte files

`groups/plugins/{cmp,gitsigns,lualine,telescope,treesitter}.lua` are empty and not
in `M.enabled`. Delete them. The base groups in `editor.lua` already carry
telescope/cmp/lualine/gitsigns.

### 6. Four unused palette keys, three of which contradict the "1:1 port" claim

| Key | Documented Zed role | Unused; theme instead uses |
| --- | --- | --- |
| `bg_dark #1d202b` | `tab.inactive_background` | `TabLine` = `element` |
| `wrap_guide #1b1e2e` | `editor.wrap_guide` | `ColorColumn` = `surface` |
| `element_hover #414559` | `element.hover` | — (see item 2) |
| `border #212538` | `border` / `pane_group.border` | every float/split = `border_accent` |

`border` going unused is deliberate — floats and splits use the vivid cyan
`border_accent` by choice. Either delete the key or comment it as intentional so
it stops reading as an oversight.

### 7. lualine theme bypasses the palette API

`lua/lualine/themes/tokyoppuccin-storm.lua:6` reads `require("tokyoppuccin.palette").storm`
directly instead of `.get(style)`, so it ignores `on_colors`. A user who remaps a
color gets a statusline that doesn't match their own config. Becomes a real bug the
moment a second variant exists.

### 8. Terminal ANSI 5 and 13 are identical

Both `#f4b8e4`. Bright magenta isn't brighter than magenta.

## Tier 3 — distribution blockers

### 9. `:colorscheme tokyoppuccin` fails

Only `colors/tokyoppuccin-storm.lua` exists. Every dev's muscle memory and every
`install = { colorscheme = { "tokyoppuccin" } }` breaks. Needs an alias entry
point, and the same for the lualine theme name.

### 10. A treesitter query override ships to every user

`after/queries/ruby/highlights.scm` re-captures `require` / `require_relative` /
`load` / `autoload` as `@keyword.import`. A colorscheme silently changing what the
*parser* captures is surprising, and it survives switching to another theme. Put it
behind a config flag, default off.

### 11. Two config knobs are untested surface area

`styles.keywords` and `styles.functions` default to `{}` and nothing ever populates
them. They work, but no one has exercised them.

### 12. Missing plugin coverage

Installed here and currently running on fallbacks: `bufferline.nvim`,
`which-key.nvim`, `noice.nvim`, `trouble.nvim`, `todo-comments.nvim`. Toward
tokyonight parity, later: neo-tree, indent-blankline, treesitter-context, flash,
other `mini.*`, dap, lazy, mason, rainbow-delimiters.

---

## Recently fixed

- **`mini.icons` had no groups at all.** mini's own `default = true` fallbacks
  linked `Cyan`→`DiagnosticHint` (grey), `Orange`→`DiagnosticWarn` (identical to
  Yellow), `Purple`→`Constant`. Added `groups/plugins/mini_icons.lua`.
- **`Constant` was never defined**, so it fell back to Neovim's `NvimLightGrey2` —
  greying purple icons plus all legacy non-treesitter constants. Now `c.orange`.
- **Dashboard collapsed three roles into one tone.** tokyonight's `Desc`=cyan and
  `Icon`/`Footer`=blue1 both landed on `c.cyan` via the `blue1->cyan` mapping. Desc
  is now `c.pink`, Icon/Footer `c.border_accent`.

## Open decisions

- **Variants:** storm-only, or derive `night`/`moon`/`day` like tokyonight?
- **Zed source of truth:** the theme originates in `EmmanuelVernet/zed-tokyoppuccin`.
  Hand-maintain the palette here, or generate it from the Zed JSON?
- **`extras/`:** export the palette to other apps (tmux, kitty, wezterm) as
  tokyonight does?
- **lualine mode colors:** currently normal=cyan, insert=green, visual=mauve,
  replace=red, command=yellow, terminal=teal. Revisit if a more Catppuccin-y mode
  palette is wanted.
