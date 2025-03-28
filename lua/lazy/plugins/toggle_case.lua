return {
	dir = vim.fn.stdpath("config") .. '/lua/local/toggle_case',
	config = function()
		local tc = require('local.toggle_case')
		vim.api.nvim_create_user_command("ToggleCase", tc.ToggleCase, {})
		vim.api.nvim_set_keymap("n", "<leader>tc", "<cmd>ToggleCase<CR>",
			{ noremap = true, silent = true, desc = "Toggle case of word" })
		vim.api.nvim_set_keymap("v", "<leader>tc", "<cmd>ToggleCase<CR>",
			{ noremap = true, silent = true, desc = "Toggle case of selection" })
	end
}
