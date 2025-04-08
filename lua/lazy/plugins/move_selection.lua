return {
  dir = vim.fn.stdpath 'config' .. '/lua/plugins/move_selection',
  name = 'move_selection',
  config = function()
    require('plugins.move_selection').setup()
  end,
  lazy = true,
}
