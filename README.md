# tokyoppuccin.nvim

A Neovim colorscheme ported 1:1 from the Zed theme **Tokyoppuccin Storm** — a
Catppuccin-flavored take on Tokyo Night Storm.

> **Status: usable, pre-1.0.** Licensed, installable, and in daily use. No
> screenshots and no CI yet, and the backlog below is still open. Treat this
> README as working notes until those land.

## Requirements

Neovim **0.10+** (uses `@lsp.*` semantic-token groups and `nvim_get_hl`).

## Install

```lua
{ "EmmanuelVernet/tokyoppuccin.nvim", lazy = false, priority = 1000 }
```

```vim
:colorscheme tokyoppuccin          " whichever style setup{} configured
:colorscheme tokyoppuccin-storm    " pin a variant regardless of config
```

Either name works. `vim.g.colors_name` is always the suffixed form
(`tokyoppuccin-storm`), so lualine's `theme = "auto"` resolves correctly.

## Config

```lua
require("tokyoppuccin").setup({
  style = "storm",
  transparent = false,      -- clear Normal/NormalFloat/SignColumn backgrounds
  terminal_colors = true,   -- set vim.g.terminal_color_*
  ruby_queries = false,     -- opt-in treesitter overrides, see below
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

### Ruby query overrides

`ruby_queries = true` appends `extras/` to the runtimepath, which activates
`extras/queries/ruby/highlights.scm`. It changes three things:

| Token | Default | With the flag |
| --- | --- | --- |
| `require` etc. **inside** a class/module/method | `@function.call` | `@keyword.import` |
| `autoload` | `@function.call` | `@keyword.import` |
| `begin` | `@keyword` | `@keyword.exception` |

Top-level `require` is already `@keyword.import` upstream — nvim-treesitter
scopes its rule to `(program)`, so only nested calls need the override. `begin`
exists because `rescue`/`ensure` are re-captured as `@keyword.exception` upstream
and `begin` is not, which splits one construct across two colors.

**Off by default** — a colorscheme changing what the *parser* captures is
surprising. The overrides are also torn down on `ColorSchemePre` when a
non-`tokyoppuccin*` scheme loads, so they never leak into another theme:
the runtimepath entry is removed, the memoized query cache is cleared, and live
Ruby buffers are restarted.

## Layout

```
colors/
├── tokyoppuccin.lua               -- unsuffixed alias -> load() with configured style
└── tokyoppuccin-storm.lua         -- thin entry point -> load("storm")
lua/tokyoppuccin/
├── init.lua                       -- setup(opts) + load(style); hi clear, apply, terminal colors
├── config.lua                     -- defaults + vim.tbl_deep_extend user merge
├── palette.lua                    -- THE color table, keyed by style
├── theme.lua                      -- build(opts) -> groups, colors, opts
├── util.lua                       -- blend helpers
└── groups/
    ├── init.lua                   -- editor + syntax + plugins
    ├── editor.lua                 -- UI shell, diagnostics, diff, git signs, LSP references
    ├── syntax.lua                 -- legacy syntax + @treesitter + @lsp (single copy)
    └── plugins/
        ├── init.lua               -- dumb `enabled` list, no auto-detect machinery
        ├── mini_icons.lua
        └── snacks.lua             -- notifier, dashboard, profiler, indent, input, picker, explorer
lua/lualine/themes/
├── tokyoppuccin.lua               -- alias
└── tokyoppuccin-storm.lua
extras/queries/ruby/highlights.scm -- OFF the rtp unless ruby_queries = true
```

Storm is the only variant. The loader is keyed on `style`, so adding one is just
another palette table.

## Port notes worth preserving

Decisions that are not derivable from the code. Match the **rendered** Zed color,
not the theme-JSON scope name.

- `this`/`super`/`self` render **teal** (`#46c4bb`), not the red the theme JSON
  lists for `variable.builtin`. Treesitter captures them at priority 100 but Ruby
  LSP's `@lsp.type.variable` overrides at 125, so the color is reasserted via
  `@lsp.typemod.variable.defaultLibrary` (127). Applied to all languages, so JS
  `this` and Python `self` match.
- The whole `keyword` family is **purple**; only import / exception / directive
  get the **hotpink** accent (`#ff8bcb`).
- Ruby instance/class vars (`@foo`, `@@foo`) arrive as `@variable.member` but must
  stay **teal** — scoped per-language via `@variable.member.ruby`.
- `@lsp.type.method.ruby` is cleared so bare calls keep treesitter `@variable`
  while explicit `.method` calls stay `@function.method.call` (blue).
- `@lsp.type.parameter.ruby` is cleared for the same reason: Ruby LSP tags every
  *reference* to a parameter, so params stayed salmon throughout a method body.
  Cleared, only the binding sites (`def foo(items)`, `|n|`) are salmon. Treesitter
  has no scope resolution, so `n` inside the block reads as a plain variable —
  that is the accepted cost.
- Ruby's `@function.builtin` is exactly nine declarative macros (`attr_*`,
  `module_function`, `include`/`extend`/`prepend`/`refine`/`using`) — `puts` is
  not in it — so `@function.builtin.ruby` narrows cleanly to `declaration #5ed2ff`
  without a query override. Orange was the wrong bucket: it means *values*
  (constants, numbers, booleans) and these are declarations.
- `@punctuation.bracket` sits on `fg_editor`, not `cyan`, following tokyonight.
  Brackets are the densest token in any file and should not outshine what they
  wrap. `@punctuation.delimiter` stays bright.
- `LspReference{Text,Read,Write}` are defined because Neovim links them to
  `Visual` by default, making an LSP occurrence indistinguishable from a real
  selection. Write is brighter than read.
- RuboCop `Style/*` offenses arrive at INFO severity → bluer teal
  (`diag_info = #0db9d7`), distinct from Zed's greener info `#81c8be`.
- `@lsp.type.class`/`namespace` link to `@type` so CamelCase decls and refs match.
- `snacks.lua` part 2 (explorer sidebar bg / names / git status) is **beyond**
  tokyonight parity — added because the flat sidebar and grey filenames were the
  specific gripes. Drop it for pure parity.

## License

MIT — see [LICENSE](LICENSE).

Derived from [tokyonight.nvim](https://github.com/folke/tokyonight.nvim)
(Apache-2.0) and the [Catppuccin](https://github.com/catppuccin/catppuccin)
Frappé palette (MIT). See [THIRD-PARTY-NOTICES.md](THIRD-PARTY-NOTICES.md).
Not affiliated with or endorsed by either project.

---

# Backlog

Ranked by how often a user would see it.

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

`groups/editor.lua`:

```lua
Pmenu    = { fg = c.fg_editor, bg = c.surface },   -- #292c3c
PmenuSel = { fg = c.fg, bg = c.bg_active },        -- #303446
```

Contrast ratio **1.13:1** — you cannot tell which completion row is selected.
`element_hover #414559` gives 1.45:1. Add `bold` too.

### 3. Message and prompt colors are Neovim's, not the theme's

After `hi clear`, Neovim 0.10+'s default colorscheme backfills every group the
theme doesn't set. Still leaking:

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

`groups/syntax.lua` sets `@markup.heading` = `c.fg` bold and nothing for `.1`–`.6`,
so every heading level looks identical. Also unset: `Bold`, `Italic`,
`@markup.quote`, `@markup.math`.

## Tier 2 — distribution

### 5. No screenshots

People choose colorschemes by looking at them. Zero images in the repo.
Realistically the biggest adoption blocker left.

### 6. No CI

A headless load test — build the theme, assert group count, assert every
`fg`/`bg`/`sp` is a string — is ~15 lines and catches a dangling palette key on
every push. `nvim_set_hl` silently ignores a `nil` colour, so nothing else will.

### 7. No tagged release

Nothing for users to pin.

### 8. Missing plugin coverage

Installed here and running on fallbacks: `bufferline.nvim`, `which-key.nvim`,
`noice.nvim`, `trouble.nvim`, `todo-comments.nvim`. Toward tokyonight parity,
later: neo-tree, indent-blankline, treesitter-context, flash, other `mini.*`, dap,
lazy, mason, rainbow-delimiters.

## Tier 3 — self-contradictions and untested surface

### 9. Three unused palette keys contradict the "1:1 port" claim

| Key | Documented Zed role | Unused; theme instead uses |
| --- | --- | --- |
| `bg_dark #1d202b` | `tab.inactive_background` | `TabLine` = `element` |
| `wrap_guide #1b1e2e` | `editor.wrap_guide` | `ColorColumn` = `surface` |
| `border #212538` | `border` / `pane_group.border` | every float/split = `border_accent` |

`border` going unused is deliberate — floats and splits use the vivid cyan
`border_accent` by choice. Either delete the key or comment it as intentional so
it stops reading as an oversight.

### 10. lualine theme bypasses the palette API

`lua/lualine/themes/tokyoppuccin-storm.lua` reads
`require("tokyoppuccin.palette").storm` directly instead of `.get(style)`, so it
ignores `on_colors`. A user who remaps a color gets a statusline that doesn't
match their own config. Becomes a real bug the moment a second variant exists.

### 11. Terminal ANSI 5 and 13 are identical

Both `#f4b8e4`. Bright magenta isn't brighter than magenta.

### 12. Two config knobs are untested surface area

`styles.keywords` and `styles.functions` default to `{}` and nothing ever
populates them. They work, but no one has exercised them.

---

## Recently fixed

- **No license.** `LICENSE` was 0 bytes — all rights reserved by default, so
  nobody could legally depend on it. Now MIT, with tokyonight's Apache-2.0 text
  and Catppuccin attribution in `THIRD-PARTY-NOTICES.md`.
- **`:colorscheme tokyoppuccin` failed.** Only the `-storm` file existed. Added
  unsuffixed aliases for both the colorscheme and the lualine theme.
- **The Ruby query override shipped to every user.** Moved from `after/queries/`
  to `extras/`, off the runtimepath unless `ruby_queries = true`.
- **`LspReference*` fell back to `Visual`**, so an LSP occurrence looked like a
  selection. Now `bg_active` / `element_hover`.
- **Five 0-byte files** in `groups/plugins/` — deleted.
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
  tokyonight does? Note `extras/` is now the ruby-queries directory, so that would
  need a different name.
- **lualine mode colors:** currently normal=cyan, insert=green, visual=mauve,
  replace=red, command=yellow, terminal=teal. Revisit if a more Catppuccin-y mode
  palette is wanted.
