local function set_title()
  vim.fn.printf 'Changing title'
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':t') -- Get current directory name
  local title = 'Neovim - ' .. cwd
  os.execute("wezterm cli set-tab-title '" .. title .. "'")
end

vim.api.nvim_create_autocmd('DirChanged', {
  pattern = '*',
  callback = function()
    vim.schedule(set_title)
  end,
})

-- Run on startup as well
vim.api.nvim_create_autocmd('VimEnter', {
  pattern = '*',
  callback = function()
    vim.cmd 'SetTitle'
  end,
})
