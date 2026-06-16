-- Monokai Charcoal palette.
-- Colors lifted from the canonical VSCode theme (74th/vscode-monokaicharcoal):
-- a true-black, high-contrast take on classic Monokai with a cyan "charcoal" frame.

local M = {}

M.colors = {
  -- backgrounds (true black, high contrast)
  bg        = "#000000", -- editor background
  bg_dark   = "#000c18", -- deep navy, used for raised floats / sidebar wells
  bg_nav    = "#060621", -- marker navigation well
  bg_cursor = "#101010", -- cursorline / hover row
  bg_visual = "#3a5278", -- selection (darkened from the theme's #6688cc)
  bg_sel    = "#6688cc", -- raw editor selection accent

  -- foregrounds
  fg        = "#ffffff", -- primary text
  fg_dim    = "#cfcfc2", -- muted text (JSON strings, inactive)
  fg_gutter = "#3b3a32", -- invisibles / whitespace
  grey      = "#75715e", -- comment-grey (diff headers, deemphasis)
  grey_soft = "#8f8f8f", -- separators

  -- the charcoal frame accent
  accent     = "#43b9d8", -- line numbers, UI chrome, titles
  border     = "#1f5563", -- window/float borders (frame accent blended onto black)
  border_dim = "#143a44", -- subtle splits

  -- classic Monokai syntax
  orange = "#fd971f", -- comments, parameters, hints
  yellow = "#e6db74", -- strings
  purple = "#ae81ff", -- numbers, constants, booleans
  pink   = "#f92672", -- keywords, storage, tags, operators
  cyan   = "#66d9ef", -- types, builtins, support functions
  green  = "#a6e22e", -- functions, classes, attributes

  -- diagnostics / git (drawn from the theme's ANSI + diff colors)
  red    = "#f82a5d",
  warn   = "#fd971f",
  info   = "#43b9d8",
  hint   = "#66d9ef",
  ok     = "#98d800",

  git_add    = "#a6e22e",
  git_change = "#e6db74",
  git_delete = "#f92672",

  -- terminal ANSI (1:1 with the VSCode theme)
  ansi = {
    black   = "#8f8f8f",
    red     = "#f82a5d",
    green   = "#98d800",
    yellow  = "#e7dc60",
    blue    = "#5ccaef",
    magenta = "#f57f00",
    cyan    = "#a57fff",
    white   = "#f1f1f1",
  },

  none = "NONE",
}

return M
