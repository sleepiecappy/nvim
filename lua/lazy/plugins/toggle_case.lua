return {
  dir = vim.fn.stdpath 'config' .. '/lua/plugins/toggle_case',
  name = 'toggle_case',
  config = function()
    require('plugins.toggle_case').setup()
  end,
}
