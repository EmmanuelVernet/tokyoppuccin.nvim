# tokyoppuccin.nvim

A Neovim colorscheme ported 1:1 from the Zed theme **Tokyoppuccin Storm** — a
Catppuccin-flavored take on Tokyo Night Storm.

> **Status: scaffold.** The directory tree exists but the files are empty. This
> README is the working spec for what to build. Source material lives in the
> personal config at `~/.config/nvim`.

## Objective

Turn the current `~/.config/nvim` prototype into a **standalone, distributable
colorscheme plugin** in the mold of
[folke/tokyonight.nvim](https://github.com/folke/tokyonight.nvim):

- Installable with any plugin manager, activated via `:colorscheme tokyoppuccin-storm`.
- **Zero dependency on tokyonight** — must set every highlight group itself.
- Configurable through `require("tokyoppuccin").setup({...})`.
- A single source of truth for the palette and highlight mappings.
- Ships its own treesitter query overrides and plugin integrations.

## Source material (in `~/.config/nvim`)

The prototype is split across a few files. Port them, don't reinvent:

| Source file | What to reuse | Target |
| --- | --- | --- |
| `colors/tokyoppuccin-storm.lua` | Full standalone theme: palette `c`, editor/UI groups, diagnostics, diff, syntax, treesitter, LSP, git signs, terminal colors. **This is the seed.** | split across `palette.lua`, `groups/editor.lua`, `groups/syntax.lua` |
| `lua/tokyoppuccin.lua` | Syntax-only overlay (palette `p` + `M.groups()`). **Byte-for-byte duplicate** of the syntax half of the standalone file. | fold into `groups/syntax.lua` — do NOT keep two copies |
| `after/queries/ruby/highlights.scm` | Re-captures `require`/`require_relative`/`load`/`autoload` as `@keyword.import` (hot pink). | `after/queries/ruby/highlights.scm` (copy as-is) |
| `lua/plugins/colorscheme.lua` | **Do not port** — this is LazyVim glue, not part of the theme. | — |

### Palette / port notes worth preserving

These decisions from the prototype comments must survive the refactor:

- `this`/`super`/`self` render **teal** (`#46c4bb`, `variable.special`), not the
  red the theme JSON lists for `variable.builtin`. Match the rendered color.
- The whole `keyword` family is **purple**; only the import family
  (`import`/`from`/`export`/`require`/`use`/`package`) and preprocessor
  directives get the **hotpink** accent.
- Ruby instance/class vars (`@foo`, `@@foo`) arrive as `@variable.member` but
  must stay **teal** — scoped per-language (`@variable.member.ruby`).
- RuboCop `Style/*` offenses arrive at INFO severity → render in a bluer teal
  (`diag_info = #0db9d7`), distinct from Zed's greener info.
- `@lsp.type.class`/`namespace` link to `@type` so CamelCase decls and refs match.

## Target structure

```
tokyoppuccin.nvim/
├── colors/
│   └── tokyoppuccin-storm.lua   -- entry point; thin: require("tokyoppuccin").load("storm")
├── lua/tokyoppuccin/
│   ├── init.lua                 -- setup(opts) + load(style)
│   ├── config.lua               -- default opts + user merge
│   ├── palette.lua              -- THE color table (single source of truth)
│   ├── theme.lua                -- assemble all groups from palette + config
│   ├── util.lua                 -- blend/darken/lighten helpers
│   └── groups/
│       ├── init.lua             -- collect editor + syntax + plugins
│       ├── editor.lua           -- UI shell (Normal, Pmenu, StatusLine, diagnostics, diff, terminal…)
│       ├── syntax.lua           -- legacy syntax + @treesitter + @lsp (deduped, single copy)
│       └── plugins/
│           ├── init.lua         -- dispatch to enabled integrations
│           ├── lualine.lua
│           ├── telescope.lua
│           ├── gitsigns.lua
│           ├── cmp.lua
│           └── treesitter.lua
├── after/queries/ruby/highlights.scm
├── README.md
└── LICENSE
```

## Config API to implement

```lua
require("tokyoppuccin").setup({
  style = "storm",          -- only variant for now; leave room for more
  transparent = false,      -- clear Normal/NormalFloat/SignColumn backgrounds
  terminal_colors = true,   -- set vim.g.terminal_color_*
  styles = {
    comments = { italic = true },
    keywords = {},
    functions = {},
    variables = { italic = true },
  },
  on_colors = function(colors) end,       -- mutate palette before groups build
  on_highlights = function(hl, colors) end, -- final override hook
  plugins = { all = false, auto = true },  -- which integrations to load
})
```

`colors/tokyoppuccin-storm.lua` stays thin — it just calls
`require("tokyoppuccin").load("storm")` so `:colorscheme` and lazy managers work.

## Build checklist

- [ ] `palette.lua` — lift the `c` table from `colors/tokyoppuccin-storm.lua`; one source of truth.
- [ ] `util.lua` — hex blend helpers (needed for transparent + selection approximations).
- [ ] `config.lua` — defaults + `vim.tbl_deep_extend` user merge.
- [ ] `groups/editor.lua` — UI shell + diagnostics + diff + git signs + terminal from the standalone file.
- [ ] `groups/syntax.lua` — merge the two duplicate syntax tables into one; honor `styles.*` toggles.
- [ ] `groups/plugins/*` — start with the MVP set below; expand toward tokyonight parity.
- [ ] `theme.lua` — assemble groups, apply `on_colors`/`on_highlights`, set `vim.g.colors_name`.
- [ ] `init.lua` — `setup()` stores opts; `load()` does `hi clear`/`syntax reset`, builds, applies.
- [ ] `colors/tokyoppuccin-storm.lua` — thin entry point.
- [ ] `after/queries/ruby/highlights.scm` — copy from prototype.
- [ ] README rewrite (user-facing: install, config, screenshots), LICENSE, screenshots.

### Plugin integration coverage

**MVP:** treesitter, LSP semantic tokens, gitsigns, telescope, lualine, cmp/blink.
**Full (tokyonight parity, later):** neo-tree, which-key, nvim-notify,
indent-blankline, treesitter-context, dashboard/alpha, trouble, flash, mini.*,
bufferline, dap, lazy, mason, noice, rainbow-delimiters.

## Open decisions

- **Variants:** ship only `storm`, or also derive `night`/`moon`/`day` like
  tokyonight? Currently storm-only; keep the loader keyed on `style` so adding
  variants later is just another palette.
- **Zed source of truth:** the theme originates from the Zed theme repo
  (`EmmanuelVernet/zed-tokyoppuccin`). Decide whether the palette is
  hand-maintained here or generated from the Zed JSON.
- **`extras/`:** optionally export the palette to other apps (Zed already exists;
  could add tmux, kitty, wezterm) as tokyonight does.
