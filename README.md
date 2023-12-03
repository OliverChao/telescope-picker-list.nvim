# telescope-picker-list.nvim



https://user-images.githubusercontent.com/39361033/228170293-485cb261-8607-43d1-80e7-e3956a1378e4.mp4



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

Initialize picker-list in extensions field.
```
extensions = {

  -- picker-list extensions
  picker_list = {},
}
```

1. If you want to add some options for pickers, use `opts`.
2. If you want to exclude some pickers, use `excluded_pickers`.
3. If you want to define you own pickers, use `use_pickers`.

Here is one example:

```lua
telescope.setup({
  -- other config
  extensions = {

    -- picker_list extensions
    picker_list = {
      -- some picker options
      opts = {
        project = { display_type = "full" },
        emoji = require("telescope.themes").get_dropdown({}),
        luasnip = require("telescope.themes").get_dropdown({}),
        notify = require("telescope.themes").get_dropdown({}),
      },
      -- excluded pickers which will not list
      excluded_pickers = {
        "fzf",
        "fd",
      },
      -- user defined pickers
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
    }, -- end picker-list
  }, -- end extensions
}) -- end telescope setup function

require("telescope").load_extension("fzf")
require("telescope").load_extension("luasnip")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("project")
require("telescope").load_extension("notify")

-- picker_list must be the last one
require("telescope").load_extension("picker_list")
```

If you want to register some extensions lazily, you can use `require("telescope._extensions.picker_list.main").register(extension_name)`.

The following config adds `goimpl` extension after it is loaded.

> Please note that you need make sure that telescope is loaded while activating other extensions in this way.

```lua
{
    "edolphin-ydf/goimpl.nvim",

    dependencies = {
      "nvim-telescope/telescope.nvim",
      other dependencies...
    },

    ft = "go",

    config = function()
      require("telescope").load_extension("goimpl")
      -- add goimpl to picker_list after it is loaded
      require("telescope._extensions.picker_list.main").register("goimpl")
    end,
  }
```

Another example for harpoon:
```lua
dependencies = {
  "nvim-telescope/telescope.nvim",
  other dependencies...
},
 config = function()
   require("harpoon").setup()
   require("telescope").load_extension("harpoon")

   require("telescope._extensions.picker_list.main").register("harpoon")
 end,
```

> picker-list use cache to locate all extensions for efficiency. In this way, after it is loaded, you need do some extra work to add new extensions.
> This represents an inevitable compromise solution.

### Keymap


```lua
-- neovim < 0.7
vim.api.nvim_set_keymap(
  "n",
  "<leader>fh",
  "<CMD>lua require 'telescope'.extensions.picker_list.picker_list()<CR>",
  {
    noremap = true,
    silent = true,
  }
)

-- neovim >= 0.7
vim.keymap.set(
  "n",
  "<leader>fh",
  require('telescope').extensions.picker_list.picker_list
)
```

# Inspiration
This plugin is inspired by [telescope-find-pickers](https://github.com/keyvchan/telescope-find-pickers.nvim).
