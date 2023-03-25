-- telescope modules
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local actions_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local themes = require("telescope.themes")
local builtin_pickers = require("telescope.builtin")
local extensions_pickers = require("telescope._extensions")

-- telescope-project modules

local M = {}

M.setup = function(setup_config) end

-- This creates a picker with a list of all of the pickers
M.find_pickers = function(opts)
  local opts_find_pickers = opts or themes.get_dropdown(opts)
  local opts_pickers = {
    bufnr = vim.api.nvim_get_current_buf(),
    winnr = vim.api.nvim_get_current_win(),
  }

  -- Variables that setup can change
  local result_table = {}

  local excluded = extensions_pickers._config.find_pickers.excluded or {}
  local plugin_opts = extensions_pickers._config.find_pickers.opts or {}
  local funcs = extensions_pickers._config.find_pickers.actions or {}
  -- print(vim.inspect(funcs))

  for name, item in pairs(builtin_pickers) do
    if not (vim.tbl_contains(excluded, name)) then
      result_table[name] = {
        action = funcs[name] or item or function() end,
        opt = plugin_opts[name] or opts_pickers,
      }
    end
  end

  for name, item in pairs(extensions_pickers.manager) do
    if not (vim.tbl_contains(excluded, name)) then
      result_table[name] = {
        action = funcs[name] or item[name] or function() end,
        opt = plugin_opts[name] or opts_pickers,
      }
    end
  end

  pickers
    .new(opts_find_pickers or {}, {
      prompt_title = "Find Pickers",
      results_title = "Picker",
      finder = finders.new_table({
        results = vim.tbl_keys(result_table),
      }),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = actions_state.get_selected_entry()
          if selection == nil then
            vim.notify("no such a picker")
            return
          end

          local value = selection.value
          actions.close(prompt_bufnr)
          if result_table[value] ~= nil then
            result_table[value].action(result_table[value].opt)
          end
        end)
        return true
      end,
      sorter = conf.file_sorter(opts_find_pickers),
    })
    :find()
end

return M
