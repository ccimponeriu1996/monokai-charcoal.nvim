local config = require("monokai-charcoal.config")

local M = {}

---@param opts? MonokaiCharcoalConfig
function M.setup(opts)
  config.setup(opts)
end

---Apply the colorscheme.
---@param opts? MonokaiCharcoalConfig optional one-shot overrides
function M.load(opts)
  if opts then
    config.setup(opts)
  end
  local cfg = config.options

  -- resolve palette (allow user color overrides)
  local colors = vim.deepcopy(require("monokai-charcoal.palette").colors)
  if type(cfg.on_colors) == "function" then
    cfg.on_colors(colors)
  end

  -- reset any previous scheme
  if vim.g.colors_name then
    vim.cmd("highlight clear")
  end
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end

  vim.o.termguicolors = true
  vim.o.background = "dark"
  vim.g.colors_name = "monokai-charcoal"

  -- build + apply highlights
  local groups = require("monokai-charcoal.groups").get(colors, cfg)

  if type(cfg.on_highlights) == "function" then
    local extra = cfg.on_highlights(colors) or {}
    groups = vim.tbl_deep_extend("force", groups, extra)
  elseif type(cfg.on_highlights) == "table" then
    groups = vim.tbl_deep_extend("force", groups, cfg.on_highlights)
  end

  for name, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, name, spec)
  end

  -- terminal colors
  local ansi = colors.ansi
  vim.g.terminal_color_0  = ansi.black
  vim.g.terminal_color_8  = ansi.black
  vim.g.terminal_color_1  = ansi.red
  vim.g.terminal_color_9  = ansi.red
  vim.g.terminal_color_2  = ansi.green
  vim.g.terminal_color_10 = ansi.green
  vim.g.terminal_color_3  = ansi.yellow
  vim.g.terminal_color_11 = ansi.yellow
  vim.g.terminal_color_4  = ansi.blue
  vim.g.terminal_color_12 = ansi.blue
  vim.g.terminal_color_5  = ansi.magenta
  vim.g.terminal_color_13 = ansi.magenta
  vim.g.terminal_color_6  = ansi.cyan
  vim.g.terminal_color_14 = ansi.cyan
  vim.g.terminal_color_7  = ansi.white
  vim.g.terminal_color_15 = ansi.white
end

---Expose the resolved palette (e.g. for statusline configs).
---@return table
function M.palette()
  local colors = vim.deepcopy(require("monokai-charcoal.palette").colors)
  if type(config.options.on_colors) == "function" then
    config.options.on_colors(colors)
  end
  return colors
end

return M
