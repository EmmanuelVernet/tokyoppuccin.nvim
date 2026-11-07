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

-- inverse of blend: the alpha that best mixes `fg` over `bg` into `color`
-- (least squares across channels, clamped to 0..1).
function M.unblend(color, fg, bg)
  local c, f, b = { hex2rgb(color) }, { hex2rgb(fg) }, { hex2rgb(bg) }
  local num, den = 0, 0
  for i = 1, 3 do
    num = num + (c[i] - b[i]) * (f[i] - b[i])
    den = den + (f[i] - b[i]) ^ 2
  end
  return den == 0 and 0 or math.min(1, math.max(0, num / den))
end

-- perceived luminance > 0.5 (same weights nvim uses to pick 'background').
function M.is_light(hex)
  local r, g, b = hex2rgb(hex)
  return (0.299 * r + 0.587 * g + 0.114 * b) / 255 > 0.5
end

-- tokyonight's blend_bg(hex, amount): dim a color toward the editor background
-- (the terminal's, under transparent — see theme.colors).
function M.blend_bg(c, fg, alpha)
  return M.blend(fg, alpha, c.term_bg or c.bg)
end

return M
