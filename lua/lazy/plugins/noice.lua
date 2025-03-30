return {
  'folke/noice.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  config = function()
    require('notify').setup {
      merge_duplicates = true,
      timeout = 2500,
      background_colour = '#000000',
    }
  end,
}
