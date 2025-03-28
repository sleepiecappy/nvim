return { -- You can easily change to a different colorscheme.
	-- Change the name of the colorscheme plugin below, and then
	-- change the command in the config to whatever the name of that colorscheme is.
	--
	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	'folke/tokyonight.nvim',
	priority = 1000, -- Make sure to load this before all the other start plugins.
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require('tokyonight').setup {
			styles = {
				comments = { italic = false }, -- Disable italics in comments
			},
		}
		local cs = 'tokyonight-night'
		-- Load the colorscheme here.
		-- Like many other themes, this one has different styles, and you could load
		-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
		vim.cmd.colorscheme(cs)
		vim.api.nvim_create_autocmd('BufEnter', {
			callback = function()
				vim.cmd.colorscheme(cs)
			end
		})
	end,
}
