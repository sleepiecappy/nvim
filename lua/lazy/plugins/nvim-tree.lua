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
      signcolumn = 'yes',
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
