return {
  'olimorris/codecompanion.nvim',
  lazy = false,
  config = function()
    require('codecompanion').setup {
      adapters = {
        gemini = function()
          return require('codecompanion.adapters').extend('gemini', {
            env = {
              api_key = os.getenv 'GEMINI_API_KEY',
            },
          })
        end,
      },
      strategies = {
        chat = {
          adapter = 'gemini',
        },
      },
      extensions = {
        mcphub = {
          callback = 'mcphub.extensions.codecompanion',
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
          },
        },
      },
      display = {
        action_palette = {
          provider = 'telescope',
        },
      },
    }
  end,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'ravitemer/mcphub.nvim',
    'MeanderingProgrammer/render-markdown.nvim',
  },
  keys = {
    { '<leader>aii', '<cmd>CodeCompanion<cr>', desc = 'CodeCompanion Inline assistant', mode = { 'n', 'v' }, noremap = true },
    { '<leader>aic', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'CodeCompanion Chat', mode = { 'n', 'v' }, noremap = true },
    { '<leader>aim', '<cmd>CodeCompanionCmd<cr>', desc = 'CodeCompanion Command', mode = { 'n', 'v' }, noremap = true },
    { '<leader>ai', '<cmd>CodeCompanionActions<cr>', desc = 'CodeCompanion Actions', mode = { 'n', 'v' }, noremap = true },
  },
}
