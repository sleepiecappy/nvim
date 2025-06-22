return {
  'rose-pine/neovim',
  name = 'rose-pine',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    vim.api.nvim_create_autocmd('BufEnter', {
      pattern = '*',
      callback = function()
        vim.cmd 'highlight Statusline NONE'
      end,
    })
    vim.cmd 'colorscheme rose-pine-moon'
  end,
}
