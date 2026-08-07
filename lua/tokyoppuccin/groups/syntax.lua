-- tokyoppuccin — syntax: legacy groups + treesitter @captures + LSP semantic tokens
-- Merged single copy of the two prototype tables (standalone + overlay). This is
-- the whole point of the theme; the UI shell above is deliberately conservative.
--
-- Port notes preserved from the prototype (match the RENDERED Zed color, not the
-- theme-JSON scope name):
--   * this/super/self -> teal (variable.special #46c4bb), not red.
--   * whole keyword family -> purple; only import/exception/directive -> hotpink.
--   * ruby @foo/@@foo arrive as @variable.member but stay teal (per-language scope).
--   * @lsp.type.class/namespace link to @type so CamelCase decls == refs.

return function(c, opts)
  local s = opts.styles
  -- style helpers: fold the user's styles.* toggles into a base spec
  local function comment(spec) return vim.tbl_extend("force", spec, s.comments) end
  local function var(spec) return vim.tbl_extend("force", spec, s.variables) end
  local function kw(spec) return vim.tbl_extend("force", spec, s.keywords) end
  local function fn(spec) return vim.tbl_extend("force", spec, s.functions) end

  return {
    -- Legacy vim syntax groups (non-treesitter filetypes, some plugins)
    Comment      = comment({ fg = c.comment }),
    String       = { fg = c.green },
    Character    = { fg = c.teal },
    Constant     = { fg = c.orange },
    Number       = { fg = c.orange },
    Boolean      = { fg = c.orange },
    Float        = { fg = c.orange },
    Identifier   = var({ fg = c.variable }),
    Function     = fn({ fg = c.blue }),
    Statement    = kw({ fg = c.purple }),
    Conditional  = kw({ fg = c.purple }),
    Repeat       = kw({ fg = c.purple }),
    Label        = { fg = c.label },
    Operator     = { fg = c.cyan2 },
    Keyword      = kw({ fg = c.purple }),
    Exception    = kw({ fg = c.purple }),
    PreProc      = { fg = c.hotpink },
    Include      = { fg = c.hotpink },
    Define       = { fg = c.hotpink },
    Macro        = { fg = c.mauve },
    PreCondit    = { fg = c.hotpink },
    Type         = { fg = c.yellow2 },
    TypeBuiltin  = { fg = c.mauve, italic = true },
    StorageClass = kw({ fg = c.purple }),
    Structure    = { fg = c.yellow2 },
    Typedef      = { fg = c.yellow },
    Special      = { fg = c.pink },
    SpecialChar  = { fg = c.pink },
    Tag          = { fg = c.blue2 },
    Delimiter    = { fg = c.cyan },
    Underlined   = { fg = c.blue2, underline = true },
    Error        = { fg = c.red },
    Todo         = { fg = c.constructor, italic = true },

    -- Treesitter: variables
    ["@variable"]              = var({ fg = c.variable }),
    ["@variable.builtin"]      = { fg = c.teal_var }, -- this/super/self -> teal
    ["@variable.builtin.self"] = { fg = c.teal_var },
    ["@variable.parameter"]    = { fg = c.salmon, italic = true },
    ["@variable.member"]       = { fg = c.blue2 },
    ["@variable.member.ruby"]  = { fg = c.teal_var }, -- @foo / @@foo stay teal
    ["@variable.special"]      = { fg = c.teal_var },
    ["@field"]                 = { fg = c.field },
    -- constants
    ["@constant"]              = { fg = c.orange },
    ["@constant.builtin"]      = { fg = c.orange },
    ["@constant.macro"]        = { fg = c.mauve },
    -- modules / namespaces
    ["@module"]                = { fg = c.yellow, italic = true },
    ["@namespace"]             = { fg = c.yellow, italic = true },
    ["@label"]                 = { fg = c.label },
    -- strings
    ["@string"]                = { fg = c.green },
    ["@string.documentation"]  = { fg = c.teal, italic = true },
    ["@string.regexp"]         = { fg = c.orange },
    ["@string.escape"]         = { fg = c.pink },
    ["@string.special"]        = { fg = c.pink },
    ["@string.special.symbol"] = { fg = c.symbol_red },
    ["@string.special.path"]   = { fg = c.pink },
    ["@string.special.url"]    = { fg = c.rosewater, italic = true },
    ["@character"]             = { fg = c.teal },
    ["@character.special"]     = { fg = c.pink },
    -- literals
    ["@boolean"]               = { fg = c.orange },
    ["@number"]                = { fg = c.orange },
    ["@number.float"]          = { fg = c.orange },
    -- types
    ["@type"]                  = { fg = c.yellow2 },
    ["@type.builtin"]          = { fg = c.mauve, italic = true },
    ["@type.definition"]       = { fg = c.yellow },
    ["@type.qualifier"]        = { fg = c.hotpink },
    ["@attribute"]             = { fg = c.orange },
    ["@property"]              = { fg = c.blue },
    -- functions
    ["@function"]              = fn({ fg = c.blue }),
    ["@function.builtin"]      = { fg = c.orange },
    ["@function.call"]         = fn({ fg = c.blue }),
    ["@function.macro"]        = { fg = c.teal },
    ["@function.method"]       = fn({ fg = c.blue }),
    ["@function.method.call"]  = fn({ fg = c.blue }),
    ["@constructor"]           = { fg = c.constructor },
    -- operators
    ["@operator"]              = { fg = c.cyan2 },
    -- keywords: whole family purple; only import/exception/directive -> hotpink
    ["@keyword"]                     = kw({ fg = c.purple }),
    ["@keyword.function"]            = kw({ fg = c.purple }),
    ["@keyword.type"]                = kw({ fg = c.purple }),
    ["@keyword.modifier"]            = kw({ fg = c.purple }),
    ["@keyword.coroutine"]           = kw({ fg = c.purple }),
    ["@keyword.operator"]            = kw({ fg = c.purple }),
    ["@keyword.repeat"]              = kw({ fg = c.purple }),
    ["@keyword.return"]              = kw({ fg = c.purple }),
    ["@keyword.debug"]               = kw({ fg = c.purple }),
    ["@keyword.exception"]           = { fg = c.hotpink },
    ["@keyword.conditional"]         = kw({ fg = c.purple }),
    ["@keyword.conditional.ternary"] = kw({ fg = c.purple }),
    ["@keyword.import"]              = { fg = c.hotpink },
    ["@keyword.directive"]           = { fg = c.hotpink },
    ["@keyword.directive.define"]    = { fg = c.hotpink },
    ["@keyword.export"]              = { fg = c.cyan2 },
    -- punctuation
    ["@punctuation.delimiter"]       = { fg = c.cyan },
    ["@punctuation.bracket"]         = { fg = c.cyan },
    ["@punctuation.special"]         = { fg = c.pink },
    ["@punctuation.special.symbol"]  = { fg = c.constructor },
    -- comments
    ["@comment"]               = comment({ fg = c.comment }),
    ["@comment.documentation"] = comment({ fg = c.comment_doc }),
    ["@comment.error"]         = { fg = c.red, italic = true },
    ["@comment.warning"]       = { fg = c.yellow, italic = true },
    ["@comment.hint"]          = { fg = c.blue2, italic = true },
    ["@comment.todo"]          = { fg = c.constructor, italic = true },
    ["@comment.note"]          = { fg = c.rosewater, italic = true },
    -- tags (markup / HTML / JSX)
    ["@tag"]                   = { fg = c.blue2 },
    ["@tag.attribute"]         = { fg = c.yellow, italic = true },
    ["@tag.delimiter"]         = { fg = c.teal },
    -- diff
    ["@diff.plus"]             = { fg = c.green },
    ["@diff.minus"]            = { fg = c.red },
    -- markup
    ["@markup.strong"]         = { fg = c.salmon, bold = true },
    ["@markup.italic"]         = { fg = c.salmon, italic = true },
    ["@markup.heading"]        = { fg = c.fg, bold = true },
    ["@markup.raw"]            = { fg = c.green },
    ["@markup.link"]           = { fg = c.field },
    ["@markup.link.label"]     = { fg = c.field },
    ["@markup.link.url"]       = { fg = c.blue2, italic = true },
    ["@markup.list"]           = { fg = c.cyan },
    -- legacy @text.* aliases
    ["@text.literal"]          = { fg = c.green },
    ["@text.strong"]           = { fg = c.salmon, bold = true },
    ["@text.emphasis"]         = { fg = c.salmon, italic = true },
    ["@text.uri"]              = { fg = c.blue2, italic = true, underline = true },
    ["@text.reference"]        = { fg = c.field },
    ["@text.title"]            = { fg = c.fg, bold = true },

    -- LSP semantic tokens
    ["@lsp.type.class"]      = { link = "@type" },
    ["@lsp.type.interface"]  = { fg = c.yellow, italic = true },
    ["@lsp.type.enum"]       = { fg = c.teal, bold = true },
    ["@lsp.type.enumMember"] = { fg = c.teal },
    ["@lsp.type.decorator"]  = { fg = c.orange },
    ["@lsp.type.namespace"]  = { link = "@type" },
    ["@lsp.type.parameter"]  = { link = "@variable.parameter" },
    ["@lsp.type.property"]   = { link = "@property" },
    ["@lsp.type.variable"]   = { link = "@variable" },
    -- self/super arrive as @lsp.type.variable (priority 125), which outranks
    -- treesitter's @variable.builtin (100) and would paint them plain-variable
    -- cyan. The defaultLibrary modifier (127) is the narrowest hook that hits
    -- only them, so teal wins back — same color as ruby's @foo.
    ["@lsp.typemod.variable.defaultLibrary"] = { fg = c.teal_var },
    ["@lsp.type.function"]   = { link = "@function" },
    ["@lsp.type.method"]     = { link = "@function.method" },
    ["@lsp.type.keyword"]    = { link = "@keyword" },
    ["@lsp.type.type"]       = { link = "@type" },
    -- Ruby: clear implicit-self method token so treesitter @variable (teal) shows
    -- for bare calls while explicit .method calls keep @function.method.call (blue).
    ["@lsp.type.method.ruby"] = {},
    -- Ruby: clear the parameter token too. Ruby LSP tags every reference to a
    -- parameter, method or block alike, so params stayed salmon throughout the
    -- body. Cleared, treesitter takes over and only the binding sites
    -- (`def foo(items)`, `|n|`) are salmon; body references fall back to
    -- @variable. Treesitter has no scope resolution, so `n` inside the block
    -- reads as a plain variable — that's the cost of getting `items` back.
    ["@lsp.type.parameter.ruby"] = {},
  }
end
