# Jot.nvim

Jot.nvim is a neovim plugin to quickly access your notes from anywhere you are.

![jot-demo](https://user-images.githubusercontent.com/34548959/189396016-2179a9c5-9aaa-4775-aa1f-5e6029c3898d.png)

## Installation

Using `packer.nvim`

```lua
use { 'hisbaan/jot.nvim', requires = 'nvim-lua/plenary.nvim' }
```

## Setup

Put the following in your init.lua to setup. The options displayed are the defaults and can be changed.

```lua
-- init.lua
require('jot').setup({
    search_dir = "~/Documents/",
    search_depth = 5,
    hide_search_dir = false,
    post_open_hook = function() end,
})
```

To call the plugin run the `Jot` command. Alternatively, you can use `require('jot').search()`.

To set this to a keybinding, you can use `nvim_set_keymap`

```lua
-- init.lua
vim.api.nvim_set_keymap('n', '<leader>j', '<Cmd>Jot<CR>', { noremap = true, silent = true })
```
