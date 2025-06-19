return { -- You can easily change to a different colorscheme.
  -- Change the name of the colorscheme plugin below, and then
  -- change the command in the config to whatever the name of that colorscheme is.
  --
  -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  'catppuccin/nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('catppuccin').setup {
      transparent_background = true,
      term_colors = true,
      no_italics = false,
      no_bold = false,
      integrations = {
        neotree = true,
        leap = true,
        noice = true,
        harpoon = true,
        mini = {
          enabled = true,
        },
      },
    }
    local cs = 'catppuccin-mocha'
    local colors = require('catppuccin.palettes').get_palette 'mocha'
    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    vim.cmd.colorscheme(cs)
    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function()
        vim.cmd.colorscheme(cs)
        --        vim.cmd 'highlight CursorLine guibg=NONE guifg=NONE'
        vim.cmd('highlight NotifyBackground guibg=' .. colors.mantle)
      end,
    })
  end,
}
