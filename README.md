# telescope-picker-list.nvim

<!-- Find all pickers available (includes `builtins` and `extensions`) -->
A plugin that helps you use any pickers in telescope.

1. There are too many pickers in telescope, including builtins and extensions, and some third-part plugins that integrates telescope.
2. It is hard to give any picker one mapping.
3. You need one way to easily list all pickers and then search you want, and just run this picker.

<!-- https://user-images.githubusercontent.com/28680236/147249475-d0729f2d-01cc-45d0-9ab8-b4ac511ecc24.mov -->

## Installation

Use any plugin manager you like.
### lazy
```lua
{
  "nvim-telescope/telescope.nvim",
  dependencies = {
        { "OliverChao/telescope-picker-list.nvim" },
    }
}

```
### packer
```lua
use { 'OliverChao/telescope-picker-list.nvim' }
```

## Requirements

* [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) (required)


## Config

```lua
telescope.setup({
  -- other config
  extensions = {

    -- find_picker extensions
    find_pickers = {
      opts = {
        project = { display_type = "full" },
        emoji = require("telescope.themes").get_dropdown({}),
        luasnip = require("telescope.themes").get_dropdown({}),
        notify = require("telescope.themes").get_dropdown({}),
      },
      excluded_pickers = {
        "fzf",
        "find_pickers",
        "fd",
      },
      user_pickers = {
        {
          "todo-comments",
          function()
            vim.cmd([[TodoTelescope theme=dropdown]])
          end,
        },
        {
          "urlview local",
          function()
            vim.cmd([[UrlView]])
          end,
        },
        {
          "urlview lazy",
          function()
            vim.cmd([[UrlView lazy]])
          end,
        },
      },
    },
  },
```

### Keymap


# Inspiration
This plugin is inspired by [telescope-find-pickers](https://github.com/prochri/telescope-all-recent.nvim).
