-- lua/last-edit-location/init.lua
local core = require 'plugins.last-edit-location.core'
local M = {}

local default_config = {
  max_locations = 100,
  map_prev = 'g<', -- Set to false to disable mapping
  map_next = 'g>', -- Set to false to disable mapping
}

function M.setup(user_config)
  local config = vim.tbl_deep_extend('force', {}, default_config, user_config or {})
  core.config = config -- Store merged config for core module access

  -- Create autocmd group
  local group = vim.api.nvim_create_augroup('LastEditLocationGroup', { clear = true })

  -- Define autocmds to record location on text change
  vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
    group = group,
    pattern = '*',
    callback = function()
      -- Use schedule to avoid potential issues running directly in autocmd
      vim.schedule(core.record_location)
    end,
    desc = 'Record cursor position after text change',
  })

  -- Define user commands
  vim.api.nvim_create_user_command('LastEditPrev', function()
    core.jump(-1)
  end, { desc = 'Jump to previous edit location' })

  vim.api.nvim_create_user_command('LastEditNext', function()
    core.jump(1)
  end, { desc = 'Jump to next edit location' })

  -- Define default mappings if enabled
  local function map(lhs, rhs, desc)
    if lhs and type(lhs) == 'string' then
      vim.keymap.set('n', lhs, rhs, { noremap = true, silent = true, desc = desc })
    end
  end

  map(config.map_prev, '<Cmd>LastEditPrev<CR>', 'Go to Previous Edit Location')
  map(config.map_next, '<Cmd>LastEditNext<CR>', 'Go to Next Edit Location')
end

return M
