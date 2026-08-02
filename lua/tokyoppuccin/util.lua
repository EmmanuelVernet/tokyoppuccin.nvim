-- tokyoppuccin — color helpers. Same blend semantics as tokyonight so ported
-- integrations map 1:1 (alpha = weight of the foreground color).

local M = {}

local function hex2rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

-- blend `fg` over `bg`, keeping `alpha` fraction of fg (0..1).
function M.blend(fg, alpha, bg)
  local fr, fg_, fb = hex2rgb(fg)
  local br, bg_, bb = hex2rgb(bg)
  local ch = function(f, b) return math.floor(alpha * f + (1 - alpha) * b + 0.5) end
  return string.format("#%02x%02x%02x", ch(fr, br), ch(fg_, bg_), ch(fb, bb))
end

-- tokyonight's blend_bg(hex, amount): dim a color toward the editor background.
function M.blend_bg(c, fg, alpha)
  return M.blend(fg, alpha, c.bg)
end

return M
