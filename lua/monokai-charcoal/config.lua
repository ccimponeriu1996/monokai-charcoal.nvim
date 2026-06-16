local M = {}

---@class MonokaiCharcoalConfig
M.defaults = {
  -- Use the terminal background instead of the theme's true black.
  transparent = false,
  -- Dim inactive (unfocused) windows.
  dim_inactive = false,
  -- Per-group font styles. Set a key to {} to disable styling for it.
  styles = {
    comments  = { italic = false }, -- the theme keeps comments orange + upright
    keywords  = { bold = true },
    functions = {},
    types     = { italic = true },
    variables = {},
    booleans  = {},
    strings   = {},
  },
  -- Override or add highlight groups: function(colors) return { Normal = {...} } end
  -- or a plain table { Normal = { fg = "#ff0000" } }.
  on_highlights = nil,
  -- Override palette colors: function(colors) colors.bg = "#0a0a0a" end
  on_colors = nil,
}

M.options = vim.deepcopy(M.defaults)

---@param opts? MonokaiCharcoalConfig
function M.setup(opts)
  opts = opts or {}
  local merged = vim.tbl_deep_extend("force", vim.deepcopy(M.defaults), opts)
  -- Each `styles` entry should fully replace its default (so `{}` clears a
  -- style) rather than deep-merge with it.
  if opts.styles then
    for group, style in pairs(opts.styles) do
      merged.styles[group] = style
    end
  end
  M.options = merged
end

return M
