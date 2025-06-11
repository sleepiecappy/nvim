return {
  dir = vim.fn.stdpath 'config' .. '/lua/plugins/profiler',
  name = 'profiler',
  config = function()
    require('plugins.profiler').setup()
  end,
}
