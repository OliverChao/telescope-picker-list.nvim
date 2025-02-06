-- telescope modules
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local actions_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local themes = require("telescope.themes")

local M = require("telescope-picker-list")

M.setup = function(setup_config) end

-- This creates a picker with a list of all of the pickers
M.picker_list = function(opts)
	local opts_list_picker = opts or themes.get_dropdown(opts)

	pickers
		.new(opts_list_picker or {}, {
			prompt_title = "Pickers",
			results_title = "Picker",
			finder = finders.new_table({
				results = vim.tbl_keys(M.results),
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
					if M.results[value] ~= nil then
						M.results[value].action(M.results[value].opt)
					end
				end)
				return true
			end,
			sorter = conf.file_sorter(opts_list_picker),
		})
		:find()
end

return M
