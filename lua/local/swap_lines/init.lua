local M = {}

function M.SwapLines(other_line)
  local line1 = vim.fn.getline '.' -- Get current line
  local line2 = vim.fn.getline(other_line) -- Get next line
  if line2 == '' then
    return
  end -- Prevent swapping if at the last line

  vim.fn.setline(vim.fn.line '.', line2) -- Swap lines
  vim.fn.setline(other_line, line1)
  vim.api.nvim_win_set_cursor(0, { other_line, 0 })
end

function M.SwapLinesUp()
  M.SwapLines(vim.fn.line '.' - 1)
end

function M.SwapLinesDown()
  M.SwapLines(vim.fn.line '.' + 1)
end

return M

