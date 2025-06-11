return {
  dir = vim.fn.stdpath 'config' .. '/lua/plugins/smart-tab',
  name = 'smart-tab',
  config = function()
    require('plugins.smart-tab').setup()
  end,
}
