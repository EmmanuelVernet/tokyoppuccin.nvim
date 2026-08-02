;; extends

; Color require-family calls as imports (keyword.import = hot pink), matching the
; Zed "Tokyoppuccin Storm" theme. Neovim's Ruby parser tags these as @function.call
; (blue); this override re-captures them so the colorscheme's @keyword.import applies.
(call
  method: (identifier) @keyword.import
  (#any-of? @keyword.import "require" "require_relative" "load" "autoload")
  (#set! "priority" 105))
