local autocmd = vim.api.nvim_create_autocmd
local notify = vim.notify

local function set_title()
  local cwd = vim.fn.fnamemodify(vim.fn.getcwd(), ':t') -- Get current directory name
  local title = 'Neovim - ' .. cwd
  -- Escape single quotes in the title to prevent shell injection
  local escaped_title = title:gsub("'", "'\\''")
  os.execute("wezterm cli set-tab-title '" .. escaped_title .. "'")
end

vim.api.nvim_create_user_command('SetTitle', function()
  vim.schedule(set_title)
end, {})

autocmd('TextYankPost', {
  pattern = '*',
  callback = function()
    local lines = vim.v.event.regcontents
    local msg

    if lines and #lines > 0 then
      local count = #lines

      if count == 1 and lines[1] then
        local char_count = #lines[1]
        msg = string.format('%d character%s yanked', char_count, char_count == 1 and '' or 's')
      else
        msg = string.format('%d line%s yanked', count, count == 1 and '' or 's')
      end
    else
      msg = 'Empty yank'
    end

    notify(msg, vim.log.levels.INFO, { title = 'Yank' })
  end,
})
autocmd('DirChanged', {
  pattern = '*',
  callback = function()
    vim.schedule(set_title)
  end,
})

-- Save all modified buffers when any buffer is written
autocmd('BufWritePost', {
  pattern = '*',
  callback = function()
    local current_buf = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].modified then
        local buf_name = vim.api.nvim_buf_get_name(buf)
        if buf_name ~= '' then -- Only save named buffers
          vim.api.nvim_buf_call(buf, function()
            vim.cmd 'silent! write'
          end)
        end
      end
    end
  end,
  group = vim.api.nvim_create_augroup('AutoSaveAllBuffers', { clear = true }),
})

-- Run on startup as well
autocmd('VimEnter', {
  pattern = '*',
  callback = function()
    vim.cmd 'SetTitle'
  end,
})
-- Make :bd and :q behave as usual when tree is visible
autocmd({'BufEnter', 'QuitPre'}, {
  nested = false,
  callback = function(e)
    local tree = require('nvim-tree.api').tree

    -- Nothing to do if tree is not opened
    if not tree.is_visible() then
      return
    end

    -- How many focusable windows do we have? (excluding e.g. incline status window)
    local winCount = 0
    for _,winId in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_config(winId).focusable then
        winCount = winCount + 1
      end
    end

    -- We want to quit and only one window besides tree is left
    if e.event == 'QuitPre' and winCount == 2 then
      vim.api.nvim_cmd({cmd = 'qall'}, {})
    end

    -- :bd was probably issued an only tree window is left
    -- Behave as if tree was closed (see `:h :bd`)
    if e.event == 'BufEnter' and winCount == 1 then
      -- Required to avoid "Vim:E444: Cannot close last window"
      vim.defer_fn(function()
        -- close nvim-tree: will go to the last buffer used before closing
        tree.toggle({find_file = true, focus = true})
        -- re-open nivm-tree
        tree.toggle({find_file = true, focus = false})
      end, 10)
    end
  end
})
