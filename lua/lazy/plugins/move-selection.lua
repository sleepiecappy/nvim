return {
  dir = vim.fn.stdpath 'config' .. '/lua/plugins/move-selection',
  name = 'move-selection',
  config = function()
    require('plugins.move-selection').setup()
  end,
}
