local M = {}

require 'plugins.sleepy-line.core'
local components = require 'plugins.sleepy-line.components'

function M.setup()
  local group = vim.api.nvim_create_augroup('Statusline', { clear = true })
  vim.api.nvim_create_autocmd({ 'WinEnter', 'BufEnter' }, {
    group = group,
    pattern = '*',
    callback = function()
      vim.opt_local.statusline = '%!v:lua.Statusline.active()'
      components.colorize()
    end,
  })
  vim.api.nvim_create_autocmd({ 'WinLeave', 'BufLeave' }, {
    group = group,
    pattern = '*',
    callback = function()
      vim.opt_local.statusline = '%!v:lua.Statusline.inactive()'
      components.colorize()
    end,
  })
end
return M
