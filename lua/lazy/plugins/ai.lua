return {
  -- codecompanion configuration with copilot autocompletion
  'olimorris/codecompanion.nvim',
  opts = {
    adapters = {
      copilot = function()
        return require('codecompanion.adapters').extend('copilot', {
          schema = {
            model = {
              default = vim.g.ai_model,
            },
          },
        })
      end,
    },
    prompt_library = require 'prompt_library',
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
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'ravitemer/mcphub.nvim',
    {
      'MeanderingProgrammer/render-markdown.nvim',
      ft = { 'markdown', 'codecompanion' },
    },
    {
      'echasnovski/mini.diff',
      config = function()
        local diff = require 'mini.diff'
        diff.setup {
          -- Disabled by default
          source = diff.gen_source.git(),
        }
      end,
    },
    {
      'zbirenbaum/copilot.lua',
      opts = {
        suggestion = {
          auto_trigger = true,
          debounce = 200,
        },
        copilot_model = vim.g.ai_model,
        filetypes = {
          markdown = true,
          sh = function()
            if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
              return false
            else
              return true
            end
          end,
        },
      },
      keys = {
        {
          '<C-l>',
          function()
            require('copilot.suggestion').accept()
          end,
          mode = 'i',
          desc = 'Accept Copilot suggestion',
        },
        {
          '<C-S-l>',
          function()
            require('copilot.suggestion').accept_word()
          end,
          mode = 'i',
          desc = 'Accept Copilot suggestion word',
        },
        {
          '<S-Tab>',
          function()
            require('copilot.suggestion').prev()
          end,
          mode = 'i',
          desc = 'Previous Copilot suggestion',
        },
      },
    },
  },
}
