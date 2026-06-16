-- lualine theme matching monokai-charcoal.
local p = require("monokai-charcoal").palette()

local function mode(fg)
  return { a = { fg = p.bg, bg = fg, gui = "bold" }, b = { fg = p.fg, bg = p.bg_dark }, c = { fg = p.accent, bg = p.bg_dark } }
end

return {
  normal   = mode(p.accent),
  insert   = mode(p.green),
  visual   = mode(p.pink),
  replace  = mode(p.orange),
  command  = mode(p.yellow),
  terminal = mode(p.cyan),
  inactive = {
    a = { fg = p.grey, bg = p.bg_dark },
    b = { fg = p.grey, bg = p.bg_dark },
    c = { fg = p.grey, bg = p.bg_dark },
  },
}
