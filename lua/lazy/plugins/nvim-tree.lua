return {
  'nvim-tree/nvim-tree.lua',
  version = 'v1',
  event = 'VeryLazy',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    disable_netrw = true,
    hijack_netrw = true,
    update_cwd = true,
    sort = {
      sorter = 'case_sensitive',
      folders_first = true,
    },
    diagnostics = {
      enable = true,
      icons = {
        hint = '󰌵',
        info = '󰋼',
        warning = '󰀪',
        error = '󰅙',
      },
    },
    view = {
      width = 30,
      side = 'right',
      signcolumn = 'no',
    },
    renderer = {
      group_empty = true,
      icons = {
        show = {
          file = false,
          folder = false,
          folder_arrow = true,
          git = false,
          modified = false,
        },
      },
    },
    filesystem_watchers = {
      enable = true,
      debounce_delay = 50,
      ignore_dirs = {
        '/.git',
        '/node_modules',
        '/.cache',
        '/build',
        '/dist',
        '/vendor',
        '/.next',
        '/.nuxt',
        '/.vscode',
        '/.idea',
        '/.sass-cache',
        '/target',
        '/out',
      },
    },
  },
  keys = {
    {
      '=',
      function()
        require('nvim-tree.api').tree.toggle()
      end,
      desc = 'Toggle NvimTree',
    },
    {
      '=f',
      function()
        require('nvim-tree.api').tree.find_file(true)
      end,
      desc = 'Find File in NvimTree',
    },
  },
}
