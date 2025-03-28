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
      no_italics = true,
      no_bold = true,
      integrations = {
        neotree = true,
        harpoon = true,
        mini = {
          enabled = true,
        },
      },
      color_overrides = {
        mocha = {
          text = '#F4CDE9',
          subtext1 = '#DEBAD4',
          subtext0 = '#C8A6BE',
          overlay2 = '#B293A8',
          overlay1 = '#9C7F92',
          overlay0 = '#866C7D',
          surface2 = '#705867',
          surface1 = '#5A4551',
          surface0 = '#44313B',

          base = '#352939',
          mantle = '#211924',
          crust = '#1a1016',
        },
      },
    }
    local cs = 'catppuccin-latte'
    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    vim.cmd.colorscheme(cs)
    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function()
        vim.cmd.colorscheme(cs)
      end,
    })
  end,
}
