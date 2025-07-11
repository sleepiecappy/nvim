local M = {}

local config = {
  enabled = true,
  execution_context = 'Normal', -- "Vim" or "Normal"
  write_on_empty = false,
  debounce_delay_ms = 300, -- milliseconds
  callback = nil,
  events = { 'BufWritePre', 'InsertLeave' },
  ignore_filetypes = { 'NvimTree', 'lazy', 'mason' },
  ignore_buftypes = { 'terminal', 'nofile', 'help' },
  auto_enable_in_insert_mode = false,
}

local saving = false
local timer = nil

-- Function to save the current buffer
local function save_buffer()
  if saving then
    return
  end

  -- Cancel any pending save
  if timer then
    timer:stop()
  end

  -- Create a debounced save
  if config.debounce_delay_ms > 0 then
    timer = vim.defer_fn(function()
      do_save()
    end, config.debounce_delay_ms)
    return
  end

  do_save()
end

-- Actual save implementation
local function do_save()
  local buf = vim.api.nvim_get_current_buf()
  if buf == 0 then
    return
  end

  -- Check if the buffer is valid.
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local modifiable = vim.api.nvim_get_option_value('modifiable', { buf = buf })
  local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
  local filetype = vim.api.nvim_get_option_value('filetype', { buf = buf })
  local is_empty = #vim.api.nvim_buf_get_lines(buf, 0, -1, false) == 0
  local readonly = vim.api.nvim_get_option_value('readonly', { buf = buf })

  -- Check if autosave is enabled
  if not config.enabled then
    return
  end

  -- Check if buffer is readonly or not modifiable
  if readonly or not modifiable then
    return
  end

  -- Check if buffer type or file type is ignored
  if vim.tbl_contains(config.ignore_buftypes, buftype) or vim.tbl_contains(config.ignore_filetypes, filetype) then
    return
  end

  -- Check if buffer is empty and write_on_empty is false
  if is_empty and not config.write_on_empty then
    return
  end

  saving = true
  -- Use a pcall to catch any errors during the save process.
  local ok, err = pcall(function()
    if config.execution_context == 'Vim' then
      vim.cmd 'silent write'
    else
      vim.api.nvim_command 'silent write'
    end
  end)

  if ok then
    if config.callback then
      config.callback()
    end
  else
    vim.notify('Failed to save: ' .. tostring(err), vim.log.levels.ERROR)
  end
  saving = false
end

-- Function to enable autosave
function M.enable()
  config.enabled = true
  vim.notify('Autosave enabled', vim.log.levels.INFO)
end

function M.disable()
  config.enabled = false
  if timer then
    timer:stop()
    timer = nil
  end
  vim.notify('Autosave disabled', vim.log.levels.INFO)
end

function M.toggle()
  config.enabled = not config.enabled

  -- Handle timer if disabling
  if not config.enabled and timer then
    timer:stop()
    timer = nil
  end

  vim.notify('Autosave ' .. (config.enabled and 'enabled' or 'disabled'), vim.log.levels.INFO)
end

-- Setup function
function M.setup(options)
  config = vim.tbl_deep_extend('force', config, options or {})

  -- Define commands
  vim.api.nvim_create_user_command('AutosaveEnable', M.enable, { desc = 'Enable autosave' })
  vim.api.nvim_create_user_command('AutosaveDisable', M.disable, { desc = 'Disable autosave' })
  vim.api.nvim_create_user_command('AutosaveToggle', M.toggle, { desc = 'Toggle autosave' })

  -- Setup autocommands.  Use a loop to create them.
  for _, event in ipairs(config.events) do
    vim.api.nvim_create_autocmd(event, {
      callback = save_buffer,
      group = vim.api.nvim_create_augroup('nvim-autosave', { clear = true }),
    })
  end

  if config.auto_enable_in_insert_mode then
    vim.api.nvim_create_autocmd('InsertEnter', {
      callback = M.enable,
      group = vim.api.nvim_create_augroup('nvim-autosave-insert-enter', { clear = true }),
    })
    vim.api.nvim_create_autocmd('InsertLeave', {
      callback = M.disable,
      group = vim.api.nvim_create_augroup('nvim-autosave-insert-leave', { clear = true }),
    })
  end
end

return M
