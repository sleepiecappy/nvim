-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  enabled = false,
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F7>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: See last session result.',
    },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'
    local dap_virtual_text = require 'nvim-dap-virtual-text'

    dap_virtual_text.setup {}

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
      },
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    -- vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    -- local breakpoint_icons = vim.g.have_nerd_font
    --     and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
    --   or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    -- for type, icon in pairs(breakpoint_icons) do
    --   local tp = 'Dap' .. type
    --   local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
    --   vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    -- end

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close
    -- Example language-specific configurations (replace with your needs)
    -- Python (requires nvim-dap-python)
    dap.configurations.python = {
      {
        name = 'Launch Current File',
        type = 'python',
        request = 'launch',
        program = '${file}',
        cwd = '${workspaceFolder}',
        console = 'integratedTerminal',
        justMyCode = false, -- Set to true for better performance in most cases
      },
    }

    -- Example using node directly (you might prefer "chrome" or "pwa-node")
    dap.configurations.javascript = {
      {
        name = 'Launch Node',
        type = 'node',
        request = 'launch',
        program = '${file}',
        cwd = '${workspaceFolder}',
      },
    }

    local function is_dart_dir()
      local l = vim.fn.getcwd() .. '/pubspec.yaml'
      return vim.fn.filereadable(l) == 1
    end

    -- Function to get the Flutter SDK path using fvm
    local function get_fvm_flutter_sdk_path()
      local path = vim.fn.getcwd() .. '/.fvm/flutter_sdk'
      if vim.fn.isdirectory(path) == 1 then
        return path
      else
        require('notify').notify('No fvm flutter_sdk found. Please run `fvm use` in your project directory.', 'error', { title = 'FVM Flutter SDK Not Found' })
        return nil
      end
    end

    if is_dart_dir() then
      -- Configure DAP for Dart using fvm
      dap.configurations.dart = {
        {
          name = 'Launch Dart Program',
          type = 'dart',
          request = 'launch',
          program = '${file}',
          cwd = '${workspaceFolder}',
          args = {},
          dartSdkPath = get_fvm_flutter_sdk_path() .. '/bin/cache/dart-sdk',
        },
      }
      -- Configure DAP for Dart using fvm
      dap.adapters.dart = {
        type = 'executable',
        command = get_fvm_flutter_sdk_path() .. '/bin/cache/dart-sdk/bin/dart',
        args = { 'debug_adapter' },
        options = {
          detached = false,
        },
      }

      dap.adapters.flutter = {
        type = 'executable',
        command = get_fvm_flutter_sdk_path() .. '/bin/flutter',
        args = { 'debug_adapter' },
        options = {
          detached = false,
        },
      }
    end
    -- Install golang specific config
  end,
}
