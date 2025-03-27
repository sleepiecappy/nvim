local M = {}

function M.ToggleCase()
	local mode = vim.fn.mode()

	if mode == "v" or mode == "V" then
		-- Get the selected text
		vim.cmd('normal! gvy')
		local text = vim.fn.getreg('"')

		-- Toggle case
		local toggled = text:gsub("%a", function(c)
			return c:match("%l") and c:upper() or c:lower()
		end)

		-- Replace selected text with toggled case
		vim.api.nvim_paste(toggled, true, -1)
	else
		-- Toggle case for the word under the cursor
		local word = vim.fn.expand("<cword>")
		if word ~= "" then
			local toggled = word:gsub("%a", function(c)
				return c:match("%l") and c:upper() or c:lower()
			end)
			vim.cmd("normal! ciw" .. toggled)
		end
	end
end

return M