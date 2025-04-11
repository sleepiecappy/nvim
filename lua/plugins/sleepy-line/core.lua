local components = require 'plugins.sleepy-line.components'

Statusline = {}

Statusline.active = function()
  return table.concat {
    '%#Statusline#',
    components.update_mode_colors(),
    components.get_mode(),
    '%#Normal# ',
    components.filepath(),
    '%#Normal# ',
    components.filename(),
    '%#Normal#',
    components.lsp(),
    '%#Normal#',
    '%=%#StatusLineExtra#',
    '',
    components.vcs(),
    components.filetype(),
    components.fileencoding(),
    components.lineinfo(),
  }
end

function Statusline.inactive()
  return ' %F'
end
