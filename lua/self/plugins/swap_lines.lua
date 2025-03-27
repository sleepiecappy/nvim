return {
	dir = vim.fn.stdpath("config") .. '/local/lua/swap_lines',
	config = function()
		local sl = require('local.lua.swap_lines.init')
		vim.api.nvim_create_user_command("SwapLinesDown", sl.SwapLinesDown, { desc = "Swap current line with the next" })
		vim.api.nvim_create_user_command("SwapLinesUp", sl.SwapLinesUp, { desc = "Swap current line with the previous" })
		vim.api.nvim_set_keymap("n", "<C-M-j>", "<cmd>SwapLinesDown<cr>", {
			desc = "Swap current line with the next"
		})
		vim.api.nvim_set_keymap("n", "<C-M-k>", "<cmd>SwapLinesUp<cr>", {
			desc = "Swap current line with the previous"
		})
	end
}
