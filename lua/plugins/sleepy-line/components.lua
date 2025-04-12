local M = {}

local modes = {
  ['n'] = 'NORMAL',
  ['no'] = 'NORMAL',
  ['v'] = 'VISUAL',
  ['V'] = 'VISUAL LINE',
  [''] = 'VISUAL BLOCK',
  ['s'] = 'SELECT',
  ['S'] = 'SELECT LINE',
  [''] = 'SELECT BLOCK',
  ['i'] = 'INSERT',
  ['ic'] = 'INSERT',
  ['R'] = 'REPLACE',
  ['Rv'] = 'VISUAL REPLACE',
  ['c'] = 'COMMAND',
  ['cv'] = 'VIM EX',
  ['ce'] = 'EX',
  ['r'] = 'PROMPT',
  ['rm'] = 'MOAR',
  ['r?'] = 'CONFIRM',
  ['!'] = 'SHELL',
  ['t'] = 'TERMINAL',
}
local color = require('catppuccin.palettes').get_palette 'mocha'
local colors = {
  ['StatusLineAccent'] = color.pink,
  ['StatuslineInsertAccent'] = color.green,
  ['StatuslineVisualAccent'] = color.blue,
  ['StatuslineReplaceAccent'] = color.maroon,
  ['StatuslineCmdLineAccent'] = color.lavender,
  ['StatuslineTerminalAccent'] = color.mauve,
  ['StatusLineExtra'] = color.blue,
  ['StatusLine'] = 'NONE',
  ['Normal'] = 'NONE',
  ['LspDiagnosticsSignError'] = color.red,
  ['LspDiagnosticsSignWarning'] = color.yellow,
  ['LspDiagnosticsSignHint'] = color.green,
  ['LspDiagnosticsSignInformation'] = color.blue,
  ['GitSignsAdd'] = color.green,
  ['GitSignsChange'] = color.yellow,
  ['GitSignsDelete'] = color.red,
}

function M.get_mode()
  local mode = vim.api.nvim_get_mode().mode
  return string.format('    %s ', modes[mode] or mode):upper()
end

function M.colorize()
  for name, hex in pairs(colors) do
    local highlight = string.format('highlight %s cterm=bold guifg=%s', name, hex)
    vim.cmd(highlight)
  end
end

function M.update_mode_colors()
  local current_mode = vim.api.nvim_get_mode().mode
  local mode_color = '%#StatusLineAccent#'
  if current_mode == 'n' then
    mode_color = '%#StatuslineAccent#'
  elseif current_mode == 'i' or current_mode == 'ic' then
    mode_color = '%#StatuslineInsertAccent#'
  elseif current_mode == 'v' or current_mode == 'V' or current_mode == '' then
    mode_color = '%#StatuslineVisualAccent#'
  elseif current_mode == 'R' then
    mode_color = '%#StatuslineReplaceAccent#'
  elseif current_mode == 'c' then
    mode_color = '%#StatuslineCmdLineAccent#'
  elseif current_mode == 't' then
    mode_color = '%#StatuslineTerminalAccent#'
  end
  return mode_color
end

function M.filepath()
  local fpath = vim.fn.fnamemodify(vim.fn.expand '%', ':~:.:h')
  if fpath == '' or fpath == '.' then
    return ' '
  end

  return string.format('   %%<%s', fpath)
end

function M.filename()
  local fname = vim.fn.expand '%:t'
  if fname == '' then
    return ''
  end
  return '   ' .. fname .. ' '
end

function M.filetype()
  local ftype = vim.bo.filetype
  if ftype == '' then
    return ''
  end
  return string.format(' %s ', ftype)
end

function M.fileencoding()
  local fenc = vim.bo.fileencoding
  if fenc == '' then
    return ''
  end
  return string.format(' %s ', fenc):upper()
end

function M.lsp()
  local count = {}
  local levels = {
    errors = 'Error',
    warnings = 'Warn',
    info = 'Info',
    hints = 'Hint',
  }

  for k, level in pairs(levels) do
    count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
  end

  local errors = ''
  local warnings = ''
  local hints = ''
  local info = ''

  if count['errors'] ~= 0 then
    errors = ' %#LspDiagnosticsSignError#  ' .. count['errors']
  end
  if count['warnings'] ~= 0 then
    warnings = ' %#LspDiagnosticsSignWarning#  ' .. count['warnings']
  end
  if count['hints'] ~= 0 then
    hints = ' %#LspDiagnosticsSignHint#  ' .. count['hints']
  end
  if count['info'] ~= 0 then
    info = ' %#LspDiagnosticsSignInformation#  ' .. count['info']
  end

  return errors .. warnings .. hints .. info .. '%#Normal#'
end

function M.lineinfo()
  if vim.bo.filetype == 'alpha' then
    return ''
  end
  return ' %l:%c '
end

function M.vcs()
  local git_info = vim.b.gitsigns_status_dict
  if not git_info or git_info.head == '' then
    return ''
  end
  local added = git_info.added and ('%#GitSignsAdd#  ' .. git_info.added .. ' ') or ''
  local changed = git_info.changed and ('%#GitSignsChange#  ' .. git_info.changed .. ' ') or ''
  local removed = git_info.removed and ('%#GitSignsDelete#  ' .. git_info.removed .. ' ') or ''
  if git_info.added == 0 then
    added = ''
  end
  if git_info.changed == 0 then
    changed = ''
  end
  if git_info.removed == 0 then
    removed = ''
  end
  return table.concat {
    ' ',
    added,
    changed,
    removed,
    ' ',
    '%#Normal# ',
    git_info.head,
    ' %#Normal#',
  }
end

return M
