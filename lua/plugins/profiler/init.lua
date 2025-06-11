local M = {}

function M.setup()
  vim.api.nvim_create_user_command('ProfilerStart', function()
    vim.cmd [[
            :profile start ~/nvim-profile.log
            :profile func *
            :profile file *
        ]]
  end, { desc = 'Starts profiling' })
  vim.api.nvim_create_user_command('ProfileStop', function()
    vim.cmd [[
   :profile stop
   :e ~/nvim-profile.log
   ]]
  end, { desc = 'Stop profiling and open log file' })
end

return M
