-- Headless test runner for monokai-charcoal.nvim.
-- Run with:  nvim --headless -l tests/run.lua   (or `make test`)

-- Make the plugin discoverable regardless of cwd.
local script = debug.getinfo(1, "S").source:sub(2)
local root = vim.fn.fnamemodify(script, ":p:h:h")
vim.opt.runtimepath:append(root)

local passed, failed = 0, 0
local function ok(name, cond, detail)
  if cond then
    passed = passed + 1
    print("ok     - " .. name)
  else
    failed = failed + 1
    print("not ok - " .. name .. (detail and ("  # got: " .. tostring(detail)) or ""))
  end
end

local function hl(name)
  return vim.api.nvim_get_hl(0, { name = name })
end
local function hex(n)
  return n and string.format("#%06x", n) or nil
end

local mc = require("monokai-charcoal")
local config = require("monokai-charcoal.config")
local groups_mod = require("monokai-charcoal.groups")

------------------------------------------------------------------ default load
mc.load({})
ok("colors_name is set", vim.g.colors_name == "monokai-charcoal", vim.g.colors_name)
ok("termguicolors enabled", vim.o.termguicolors == true)
ok("background is dark", vim.o.background == "dark")

------------------------------------------------------------- core palette wiring
ok("Normal fg white", hex(hl("Normal").fg) == "#ffffff", hex(hl("Normal").fg))
ok("Normal bg true-black", hex(hl("Normal").bg) == "#000000", hex(hl("Normal").bg))
ok("Comment is orange", hex(hl("Comment").fg) == "#fd971f", hex(hl("Comment").fg))
ok("Comment upright by default", hl("Comment").italic ~= true)
ok("Keyword pink + bold", hex(hl("Keyword").fg) == "#f92672" and hl("Keyword").bold == true)
ok("String yellow", hex(hl("String").fg) == "#e6db74", hex(hl("String").fg))
ok("Number purple", hex(hl("Number").fg) == "#ae81ff", hex(hl("Number").fg))
ok("@function green", hex(hl("@function").fg) == "#a6e22e", hex(hl("@function").fg))
ok("Type cyan + italic", hex(hl("Type").fg) == "#66d9ef" and hl("Type").italic == true)
ok("LineNr accent cyan", hex(hl("LineNr").fg) == "#43b9d8", hex(hl("LineNr").fg))

----------------------------------------------------------------------- diagnostics
ok("DiagnosticError red", hex(hl("DiagnosticError").fg) == "#f82a5d", hex(hl("DiagnosticError").fg))
ok("DiagnosticUnderlineError undercurl", hl("DiagnosticUnderlineError").undercurl == true)

------------------------------------------------------------------- treesitter/lsp
ok("@variable.parameter italic orange", hex(hl("@variable.parameter").fg) == "#fd971f"
  and hl("@variable.parameter").italic == true)
ok("@lsp.type.function green", hex(hl("@lsp.type.function").fg) == "#a6e22e")
ok("@markup.heading green bold", hex(hl("@markup.heading").fg) == "#a6e22e"
  and hl("@markup.heading").bold == true)

--------------------------------------------------------------------- terminal cols
ok("terminal_color_0 set", vim.g.terminal_color_0 == "#8f8f8f", vim.g.terminal_color_0)
ok("terminal_color_1 red", vim.g.terminal_color_1 == "#f82a5d", vim.g.terminal_color_1)
ok("terminal_color_2 green", vim.g.terminal_color_2 == "#98d800", vim.g.terminal_color_2)
ok("terminal_color_15 white", vim.g.terminal_color_15 == "#f1f1f1", vim.g.terminal_color_15)

------------------------------------------------- every group applies without error
local groups = groups_mod.get(mc.palette(), config.options)
ok("plenty of groups defined", vim.tbl_count(groups) > 300, vim.tbl_count(groups))
local bad = {}
for name, spec in pairs(groups) do
  if not pcall(vim.api.nvim_set_hl, 0, name, spec) then
    bad[#bad + 1] = name
  end
end
ok("all groups valid for nvim_set_hl", #bad == 0, table.concat(bad, ", "))

------------------------------------------------------------------------ transparent
mc.load({ transparent = true })
ok("transparent: Normal bg cleared", hl("Normal").bg == nil, hex(hl("Normal").bg))
ok("transparent: SignColumn bg cleared", hl("SignColumn").bg == nil)

------------------------------------------------------------------- on_colors hook
mc.load({ on_colors = function(c) c.bg = "#0a0a0a" end })
ok("on_colors override applied", hex(hl("Normal").bg) == "#0a0a0a", hex(hl("Normal").bg))

----------------------------------------------------- on_highlights hook (function)
mc.load({ on_highlights = function(c) return { Normal = { fg = c.fg, bg = "#123456" } } end })
ok("on_highlights(fn) applied", hex(hl("Normal").bg) == "#123456", hex(hl("Normal").bg))

-------------------------------------------------------- on_highlights hook (table)
mc.load({ on_highlights = { Comment = { fg = "#abcdef" } } })
ok("on_highlights(table) applied", hex(hl("Comment").fg) == "#abcdef", hex(hl("Comment").fg))

------------------------------------------------------------------------ styles hook
mc.load({ styles = { comments = { italic = true }, keywords = {} } })
ok("styles.comments italic", hl("Comment").italic == true)
ok("styles.keywords bold cleared", hl("Keyword").bold ~= true)

-------------------------------------------------------------- config resets per load
mc.load({})
ok("config resets: Comment upright again", hl("Comment").italic ~= true)
ok("config resets: bg back to black", hex(hl("Normal").bg) == "#000000", hex(hl("Normal").bg))

------------------------------------------------------------- :colorscheme entry path
vim.cmd("colorscheme monokai-charcoal")
ok("colorscheme command works", vim.g.colors_name == "monokai-charcoal")

------------------------------------------------------------------------ palette API
local p = mc.palette()
ok("palette.pink", p.pink == "#f92672", p.pink)
ok("palette.accent", p.accent == "#43b9d8", p.accent)
ok("palette.ansi table", type(p.ansi) == "table" and p.ansi.green == "#98d800")

------------------------------------------------------------------------ lualine theme
local ll = require("lualine.themes.monokai-charcoal")
ok("lualine normal.a.bg accent", ll.normal.a.bg == "#43b9d8", ll.normal.a.bg)
ok("lualine insert.a.bg green", ll.insert.a.bg == "#a6e22e", ll.insert.a.bg)
ok("lualine visual.a.bg pink", ll.visual.a.bg == "#f92672", ll.visual.a.bg)
ok("lualine has inactive section", type(ll.inactive) == "table")

------------------------------------------------------------------------------ report
print(string.format("\n%d passed, %d failed", passed, failed))
os.exit(failed == 0 and 0 or 1)
