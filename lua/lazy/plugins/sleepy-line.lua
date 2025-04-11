return {
  dir = vim.fn.stdpath 'config' .. '/lua/plugins/sleepy-line',
  name = 'sleepy-line',
  config = function()
    require('plugins.sleepy-line').setup()
  end,
}
