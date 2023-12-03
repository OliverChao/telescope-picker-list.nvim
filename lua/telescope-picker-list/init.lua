local builtin_pickers = require("telescope.builtin")
local extensions_pickers = require("telescope._extensions")

local M = {}
M.results = {}

local opts_pickers = {
	bufnr = vim.api.nvim_get_current_buf(),
	winnr = vim.api.nvim_get_current_win(),
}

local picker_list = extensions_pickers._config.picker_list or {}
local excluded = picker_list.excluded_pickers or {}
local plugin_opts = picker_list.opts or {}
local funcs = picker_list.actions or {}
local user_pickers = picker_list.user_pickers or {}

for _, v in ipairs(user_pickers) do
	M.results[v[1]] = {
		action = v[2],
	}
end

for name, item in pairs(builtin_pickers) do
	if not (vim.tbl_contains(excluded, name)) then
		M.results[name] = {
			action = funcs[name] or item or function() end,
			opt = plugin_opts[name] or opts_pickers,
		}
	end
end

for extension, item in pairs(extensions_pickers.manager) do
	if not (vim.tbl_contains(excluded, extension)) then
		for name, action in pairs(item) do
			local key = extension
			if name ~= extension and vim.tbl_count(item) > 1 then
				key = key .. ": " .. name
			end
			M.results[key] = {
				action = action,
				opt = plugin_opts[extension] or opts_pickers,
			}
		end
	end
end

return M
