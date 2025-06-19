vim.api.nvim_create_user_command('SetTitle', function()
  local cwd = vim.fn.getcwd()
  if not cwd then
    -- vim.notify('Could not get current working directory.', vim.log.levels.ERROR)
    return
  end

  local dir_name = vim.fs.basename(cwd)

  if dir_name == nil or dir_name == '' then
    -- vim.notify('Could not determine directory name from: ' .. cwd, vim.log.levels.ERROR)
    return
  end

  local cmd_args = { 'wezterm', 'cli', 'set-tab-title', dir_name }

  vim.system(cmd_args, { text = true }, function(obj)
    if obj.code == 0 then
      -- vim.notify('WezTerm tab title set to: ' .. dir_name, vim.log.levels.INFO)
    else
      local errmsg = 'Failed to set WezTerm tab title.'
      if obj.stderr and obj.stderr ~= '' then
        errmsg = errmsg .. ' Error: ' .. vim.trim(obj.stderr)
      elseif obj.stdout and obj.stdout ~= '' then
        errmsg = errmsg .. ' Output: ' .. vim.trim(obj.stdout)
      else
        errmsg = errmsg .. ' Exit code: ' .. obj.code
      end
      -- vim.notify(errmsg, vim.log.levels.ERROR)
    end
  end)
end, { desc = 'Set wezterm tab title' })
