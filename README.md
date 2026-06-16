# monokai-charcoal.nvim

![Neovim](https://img.shields.io/badge/Neovim-0.8+-43b9d8?style=flat-square&logo=neovim&logoColor=white)
![Lua](https://img.shields.io/badge/Made%20with-Lua-ae81ff?style=flat-square&logo=lua&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-a6e22e?style=flat-square)

A Neovim port of the [Monokai Charcoal (high contrast)](https://github.com/74th/vscode-monokaicharcoal)
VSCode theme: classic Monokai syntax over a true-black background with a cyan
"charcoal" frame. Written in Lua, with Treesitter, LSP semantic tokens,
diagnostics, terminal colors, and the common plugin ecosystem covered.

The palette is lifted 1:1 from the original VSCode theme, including its signature
choices: **orange comments**, pink keywords, green functions, cyan types, purple
constants, and yellow strings.

## Features

- True-black, high-contrast background with the original cyan frame accent
- Full Treesitter support, including the Neovim 0.10+ `@markup.*` captures
- LSP semantic token highlighting (`@lsp.type.*` / `@lsp.typemod.*`)
- Diagnostics: virtual text, underlines, and signs
- 16 terminal colors mapped from the original theme's ANSI palette
- Matching `lualine` theme bundled in
- `transparent` and `dim_inactive` toggles
- Per-group style overrides plus `on_colors` / `on_highlights` escape hatches
- Pure Lua, no dependencies, lazy-load friendly

## Supported plugins

Treesitter, native LSP, gitsigns, telescope, nvim-cmp, blink.cmp, nvim-tree,
neo-tree, bufferline, indent-blankline (v3), which-key, nvim-notify, nvim-dap /
dap-ui, mini.nvim, and rainbow-delimiters. Anything not listed inherits sensible
colors from the core syntax and editor groups.

## Requirements

- Neovim >= 0.8 (uses `vim.api.nvim_set_hl`)
- `termguicolors` enabled (the theme sets it automatically)

## Install

### lazy.nvim

```lua
{
  "ccimponeriu1996/monokai-charcoal.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("monokai-charcoal").setup({})
    vim.cmd.colorscheme("monokai-charcoal")
  end,
}
```

### packer.nvim

```lua
use({
  "ccimponeriu1996/monokai-charcoal.nvim",
  config = function()
    vim.cmd.colorscheme("monokai-charcoal")
  end,
})
```

### vim-plug

```vim
Plug 'ccimponeriu1996/monokai-charcoal.nvim'
" then, after plug#end():
colorscheme monokai-charcoal
```

Calling `setup()` is optional. Without it you can just
`:colorscheme monokai-charcoal`.

## Configuration

`setup()` is only needed to change defaults. Shown below with the defaults:

```lua
require("monokai-charcoal").setup({
  transparent = false,    -- use the terminal background instead of true black
  dim_inactive = false,   -- dim unfocused windows
  styles = {
    comments  = { italic = false }, -- comments are orange + upright (faithful)
    keywords  = { bold = true },
    functions = {},
    types     = { italic = true },
    variables = {},
    booleans  = {},
    strings   = {},
  },
  -- tweak the palette before highlights are built
  on_colors = function(colors)
    -- colors.bg = "#0a0a0a"
  end,
  -- override or add highlight groups (table or function(colors) -> table)
  on_highlights = function(colors)
    return {
      -- Comment = { fg = colors.grey },
    }
  end,
})
vim.cmd.colorscheme("monokai-charcoal")
```

### lualine

A matching lualine theme ships with the plugin:

```lua
require("lualine").setup({ options = { theme = "monokai-charcoal" } })
```

### Accessing the palette

```lua
local colors = require("monokai-charcoal").palette()
-- colors.pink, colors.accent, colors.bg, ...
```

## Palette

| Role                | Color     |
| ------------------- | --------- |
| Background          | `#000000` |
| Foreground          | `#ffffff` |
| Frame accent        | `#43b9d8` |
| Comments / params   | `#fd971f` |
| Strings             | `#e6db74` |
| Numbers / constants | `#ae81ff` |
| Keywords / tags     | `#f92672` |
| Types / builtins    | `#66d9ef` |
| Functions / classes | `#a6e22e` |

## Tests

A headless test suite checks the palette wiring, the config hooks
(`transparent`, `styles`, `on_colors`, `on_highlights`), terminal colors, the
`:colorscheme` entry path, and the lualine theme:

```sh
make test
# or: nvim --headless -l tests/run.lua
```

## Credits

- Original VSCode theme: [74th/vscode-monokaicharcoal](https://github.com/74th/vscode-monokaicharcoal)
- Monokai color scheme by Wimer Hazenberg

## License

MIT
