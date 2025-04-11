return {
  dir = vim.fn.stdpath 'config' .. '/lua/plugins/toggle-case',
  name = 'toggle-case',
  config = function()
    require('plugins.toggle-case').setup()
  end,
}
