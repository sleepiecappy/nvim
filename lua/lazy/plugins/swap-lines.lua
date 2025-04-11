return {
  dir = vim.fn.stdpath 'config' .. '/lua/plugins/swap-lines',
  name = 'swap-lines',
  config = function()
    require('plugins.swap-lines').setup()
  end,
}
