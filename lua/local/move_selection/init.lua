local M = {}

function M.MoveSelectionToNewFile()
  -- Get the selected text
  local start_line, start_col = unpack(vim.fn.getpos "'<", 2, 3)
  local end_line, end_col = unpack(vim.fn.getpos "'>", 2, 3)

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local text = table.concat(lines, '\n')

  -- Delete selected lines
  vim.cmd "'<,'>d"

  -- Ask for filename
  local filename = vim.fn.input 'Save as: '

  if filename ~= '' then
    -- Create new buffer with filename
    vim.cmd('edit ' .. filename)
    vim.api.nvim_put(vim.split(text, '\n'), 'l', true, true)
    vim.cmd 'write'
  end
end

return M
