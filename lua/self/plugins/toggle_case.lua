return {
	dir = vim.fn.stdpath("config") .. '/local/lua/toggle_case',
	config = function()
		local tc = require('local.lua.toggle_case.init')
		vim.api.nvim_create_user_command("ToggleCase", tc.ToggleCase, {})
		vim.api.nvim_set_keymap("n", "<leader>tc", "<cmd>ToggleCase<CR>",
			{ noremap = true, silent = true, desc = "Toggle case of word" })
		vim.api.nvim_set_keymap("v", "<leader>tc", "<cmd>ToggleCase<CR>",
			{ noremap = true, silent = true, desc = "Toggle case of selection" })
	end
}
