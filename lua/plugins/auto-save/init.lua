local M = {}

local noice = require 'noice'

local function is_available(name)
  return package.loaded[name] ~= nil or vim.fn.require(name, { silent = true }) ~= nil
end

-- Default configuration
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

local timer = nil
local saving = false

-- Function to save the current buffer
local function save_buffer()
  if saving then
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  if buf == 0 then
    return
  end

  -- Check if the buffer is valid.
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local modifiable = vim.api.nvim_get_option_value('modifiable', { buf = buf })
  local readonly = vim.api.nvim_get_option_value('readonly ', { buf = buf })
  local buftype = vim.api.nvim_get_option_value('buftype', { buf = buf })
  local filetype = vim.api.nvim_get_option_value('filetype', { buf = buf })
  local is_empty = #vim.api.nvim_buf_get_lines(buf, 0, -1, false) == 0

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
  end
  saving = false
end

-- Function to handle buffer changes
local function on_buf_changed()
  if timer then
    vim.timer.stop(timer)
  end
  timer = vim.timer.start(config.debounce_delay_ms, save_buffer)
end

-- Function to enable autosave
function M.enable()
  config.enabled = true
  noice.notify('Autosave enabled', vim.log.levels.INFO)
end

-- Function to disable autosave
function M.disable()
  config.enabled = false
  if timer then
    vim.timer.stop(timer)
  end
  noice.notify('Autosave disabled', vim.log.levels.INFO)
end

-- Function to toggle autosave
function M.toggle()
  config.enabled = not config.enabled
  if config.enabled then
    M.enable()
  else
    M.disable()
  end
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
      callback = on_buf_changed,
      group = vim.api.nvim_create_augroup('nvim-autosave', { clear = true }),
    })
  end

  if config.auto_enable_in_insert_mode then
    vim.api.nvim_create_autocmd('InsertEnter', {
      callback = M.enable,
      group = vim.api.nvim_create_augroup('nvim-autosave-insert', { clear = true }),
    })
    vim.api.nvim_create_autocmd('InsertLeave', {
      callback = M.disable,
      group = vim.api.nvim_create_augroup('nvim-autosave-insert', { clear = true }),
    })
  end
end

return M
