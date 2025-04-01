return {
  dir = vim.fn.stdpath 'config' .. '/lua/local/move_selection',
  config = function()
    local ms = require 'local.move_selection'
    vim.api.nvim_create_user_command('MoveSelection', ms.MoveSelectionToNewFile, { desc = 'Move selection to a new file' })
    vim.api.nvim_set_keymap('n', '<leader>ms', '<CMD>MoveSelection<CR>', { silent = true })
  end,
}
