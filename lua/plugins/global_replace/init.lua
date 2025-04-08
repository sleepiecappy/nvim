local M = {}

function M.setup()
  vim.api.nvim_create_user_command('GlobalReplace', function(opts)
    require('plugins.global_replace.global_replace').run { confirm = not opts.bang }
  end, {
    bang = true,
    desc = 'Global search and replace using Telescope + cfdo',
  })
end

return M
