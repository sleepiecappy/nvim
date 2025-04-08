return {
  dir = vim.fn.stdpath 'config' .. '/lua/plugins/swap_lines',
  name = 'swap_lines',
  config = function()
    require('plugins.swap_lines').setup()
  end,
}
