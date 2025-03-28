-- useful to set a collection of files that will be worked on, eg.
-- schema, view, repo, tests
return {
	'ThePrimeagen/harpoon',
	branch = 'harpoon2',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		local harpoon = require('harpoon')
		harpoon:setup()
		local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers").new({}, {
				prompt_title = "Harpoon",
				finder = require("telescope.finders").new_table({
					results = file_paths,
				}),
				previewer = conf.file_previewer({}),
				sorter = conf.generic_sorter({}),
			}):find()
		end



		vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end, { desc = '[H]arpoon [a]dd file' })
		vim.keymap.set('n', '<leader>hq', function() toggle_telescope(harpoon:list()) end,
			{ desc = '[H]arpoon [q]uick menu' })

		vim.keymap.set('n', '<M-1>', function() harpoon:list():select(1) end, { desc = 'Harpoon entry 1' })
		vim.keymap.set('n', '<M-2>', function() harpoon:list():select(2) end, { desc = 'Harpoon entry 2' })
		vim.keymap.set('n', '<M-3>', function() harpoon:list():select(3) end, { desc = 'Harpoon entry 3' })
		vim.keymap.set('n', '<M-4>', function() harpoon:list():select(4) end, { desc = 'Harpoon entry 4' })

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set('n', '<leader>hn', function() harpoon:list():prev() end, { desc = '[H]arpoon [p]revious entry' })
		vim.keymap.set('n', '<leader>', function() harpoon:list():next() end, { desc = '[H]arpoon [n]ext entry' })
	end,

}
