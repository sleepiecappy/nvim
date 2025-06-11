local function smart_tab_func()
  local delimiters_set = {
    ['('] = true,
    ['['] = true,
    ['{'] = true,
    [']'] = true,
    ['}'] = true,
    [')'] = true,
    [','] = true,
    [';'] = true,
    ['.'] = true,
    ['"'] = true,
    ["'"] = true,
  }

  -- Get current cursor position (0-indexed) and line content
  local cursor_pos_arr = vim.api.nvim_win_get_cursor(0)
  local current_col_0idx = cursor_pos_arr[2]
  local current_line_content = vim.api.nvim_get_current_line()

  -- Determine the 1-based index for the character to the right of the cursor in the Lua string
  local char_to_right_lua_idx = current_col_0idx + 1

  -- Check if cursor is at the end of the line or line is empty
  if char_to_right_lua_idx > #current_line_content then
    -- No character to the right, or empty line; perform default Tab action
    return vim.api.nvim_replace_termcodes('<Tab>', true, true, true)
  end

  -- Get the character to the right of the cursor
  local char_to_right = current_line_content:sub(char_to_right_lua_idx, char_to_right_lua_idx)

  if delimiters_set[char_to_right] then
    -- Character to the right is a delimiter.
    -- Move cursor one position to the right by feeding the <Right> key.
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Right>', true, false, true), 'n', false)
    -- Return an empty string as we've handled the action and don't want to insert a Tab.
    return ''
  else
    -- Character to the right is not a delimiter.
    -- Perform default Tab action.
    return vim.api.nvim_replace_termcodes('<Tab>', true, true, true)
  end
end

-- Map <Tab> in insert mode to the smart_tab_func
-- `expr = true` means the mapping expects the function to return a string of keys to execute.
-- `noremap = true` ensures the mapping is not recursive.
-- `silent = true` avoids echoing the command.
vim.keymap.set('i', '<Tab>', function()
  vim.notify('tab invoked', vim.log.levels.WARN)
  return smart_tab_func()
end, {
  expr = true,
  noremap = true,
  silent = true,
  desc = 'Smart Tab: Jump delimiter or insert Tab/complete',
})

local M = {}

function M.setup()
  smart_tab_func()
end

return M
