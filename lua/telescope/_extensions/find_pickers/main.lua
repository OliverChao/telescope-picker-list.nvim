-- telescope modules
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local actions_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local themes = require("telescope.themes")

local M = {}

local result_table = require("telescope-find-pickers").results
M.setup = function(setup_config) end

-- This creates a picker with a list of all of the pickers
M.find_pickers = function(opts)
  local opts_find_pickers = opts or themes.get_dropdown(opts)

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
