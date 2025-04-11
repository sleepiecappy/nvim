return {
  dir = vim.fn.stdpath 'config' .. '/lua/plugins/last-edit-location',
  name = 'last-edit-location',
  config = function()
    require('plugins.last-edit-location').setup()
  end,
}
