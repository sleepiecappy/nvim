vim.api.nvim_set_keymap('n', '<leader>ws', ':split<CR>', { noremap = true, silent = true, desc = 'Split horizontally' })
vim.api.nvim_set_keymap('n', '<leader>wv', ':vsplit<CR>', { noremap = true, silent = true, desc = 'Split vertically' })
vim.api.nvim_set_keymap('n', '<leader>wq', ':q<CR>', { noremap = true, silent = true, desc = 'Close Window' })
vim.api.nvim_set_keymap('n', '<leader>wl', '<C-w>l', { noremap = true, silent = true, desc = 'To Window on the left' })
vim.api.nvim_set_keymap('n', '<leader>wk', '<C-w>k', { noremap = true, silent = true, desc = 'To Window on the top' })
vim.api.nvim_set_keymap('n', '<leader>wj', '<C-w>j', { noremap = true, silent = true, desc = 'To Window on the bottom' })
vim.api.nvim_set_keymap('n', '<leader>wh', '<C-w>h', { noremap = true, silent = true, desc = 'To Window on the right' })
vim.api.nvim_set_keymap('n', '<leader>w[', '<cmd>res-1<cr>', { noremap = true, silent = true, desc = 'Resize - 1' })
vim.api.nvim_set_keymap('n', '<leader>w]', '<cmd>res+1<cr>', { noremap = true, silent = true, desc = 'Resize + 1' })
vim.api.nvim_set_keymap('n', '<leader>j', '10j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>k', '10k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>h', '^', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>l', '$', { noremap = true, silent = true })
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('i', 'jj', '<ESC>')
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('i', '<Tab>', function()
  local next_char = vim.fn.getline('.'):sub(vim.fn.col '.', vim.fn.col '.')
  if next_char:match '[%)%]%}%\'%"]' then
    return '<Right>'
  else
    return '<Tab>'
  end
end, { expr = true, noremap = true })
vim.keymap.set('n', '<leader><leader>', '<cmd>w<CR>', { desc = 'Save' })
