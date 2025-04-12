return {
  dir = vim.fn.stdpath 'config' .. '/lua/plugins/auto-save',
  name = 'auto-save',
  config = function()
    require('plugins.auto-save').setup {}
  end,
}
