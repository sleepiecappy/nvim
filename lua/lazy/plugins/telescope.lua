return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    local actions = require 'telescope.actions'
    local builtin = require 'telescope.builtin'

    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      -- defaults = {
      --   mappings = {
      --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
      --   },
      -- },

      defaults = {
        -- Optional: Customize layout, sorting, etc.
        layout_strategy = 'flex', -- Or 'horizontal', 'flex', etc.
        layout_config = {
          vertical = { prompt_position = 'top', preview_height = 0.4 },
          -- horizontal = { preview_width = 0.6 }
        },
        sorting_strategy = 'ascending',
        prompt_prefix = '  󰈳  ', -- Nerd Font icon (optional)
        selection_caret = '  󰅂 ', -- Nerd Font icon (optional)

        -- Keymappings within the Telescope window
        mappings = {
          i = { -- Mappings for Insert mode in Telescope prompt
            -- >> Picker Switching Logic <<
            ['<C-f>'] = function(prompt_bufnr) -- Ctrl+F for Files
              -- Close the current picker and open find_files
              -- Using require inside ensures the latest builtin is used if reloaded
              require('telescope.actions').close(prompt_bufnr)
              require('telescope.builtin').find_files()
            end,
            ['<C-g>'] = function(prompt_bufnr) -- Ctrl+G for Grep (Text search)
              require('telescope.actions').close(prompt_bufnr)
              require('telescope.builtin').live_grep()
            end,
            ['<C-p>'] = function(prompt_bufnr) -- Ctrl+P for Project Symbols (LSP)
              require('telescope.actions').close(prompt_bufnr)
              require('telescope.builtin').lsp_workspace_symbols() -- Needs LSP!
            end,
            ['<C-d>'] = function(prompt_bufnr) -- Ctrl+D for Document Symbols (LSP)
              require('telescope.actions').close(prompt_bufnr)
              require('telescope.builtin').lsp_document_symbols() -- Needs LSP!
            end,
            ['<C-c>'] = function(prompt_bufnr) -- Ctrl+C for Commands
              require('telescope.actions').close(prompt_bufnr)
              require('telescope.builtin').commands()
            end,
            ['<C-h>'] = function(prompt_bufnr) -- Ctrl+H for Help Tags
              require('telescope.actions').close(prompt_bufnr)
              require('telescope.builtin').help_tags()
            end,
            ['<C-b>'] = function(prompt_bufnr) -- Ctrl+B for Buffers
              require('telescope.actions').close(prompt_bufnr)
              require('telescope.builtin').buffers()
            end,
            ['<C-o>'] = function(prompt_bufnr) -- Ctrl+O for Oldfiles (Recent)
              require('telescope.actions').close(prompt_bufnr)
              require('telescope.builtin').oldfiles()
            end,
            -- Add more pickers: keymaps, git_status, git_files, etc.
            -- ["<C-k>"] = function(prompt_bufnr) require('telescope.actions').close(prompt_bufnr); require('telescope.builtin').keymaps() end,
            -- ["<C-t>"] = function(prompt_bufnr) require('telescope.actions').close(prompt_bufnr); require('telescope.builtin').git_status() end,

            -- Default Telescope actions (important!)
            ['<esc>'] = actions.close,
            ['<CR>'] = actions.select_default + actions.center, -- Open selection
            ['<C-x>'] = actions.select_horizontal, -- Open in horizontal split
            ['<C-v>'] = actions.select_vertical, -- Open in vertical split
            ['<C-t>'] = actions.select_tab, -- Open in new tab
            ['<C-j>'] = actions.move_selection_next, -- Move selection down
            ['<C-k>'] = actions.move_selection_previous, -- Move selection up
            ['<PageUp>'] = actions.preview_scrolling_up,
            ['<PageDown>'] = actions.preview_scrolling_down,
            -- Add other standard actions you use
          },
          n = { -- Mappings for Normal mode in Telescope results list
            ['q'] = actions.close,
            -- Add normal mode equivalents for switching if desired
            ['<C-f>'] = function()
              require('telescope.builtin').find_files()
            end,
            ['<C-g>'] = function()
              require('telescope.builtin').live_grep()
            end,
            ['<C-p>'] = function()
              require('telescope.builtin').lsp_workspace_symbols()
            end,
            ['<C-d>'] = function()
              require('telescope.builtin').lsp_document_symbols()
            end,
            ['<C-c>'] = function()
              require('telescope.builtin').commands()
            end,
            ['<C-h>'] = function()
              require('telescope.builtin').help_tags()
            end,
            ['<C-b>'] = function()
              require('telescope.builtin').buffers()
            end,
            ['<C-o>'] = function()
              require('telescope.builtin').oldfiles()
            end,
            -- Keep default normal mode actions
            ['<CR>'] = actions.select_default + actions.center,
            ['<C-x>'] = actions.select_horizontal,
            ['<C-v>'] = actions.select_vertical,
            ['<C-t>'] = actions.select_tab,
            ['j'] = actions.move_selection_next,
            ['k'] = actions.move_selection_previous,
            -- Add others as needed
          },
        },
      },
      extensions = {
        -- Optional: Configure extensions like fzf-native or ui-select here
        fzf = {
          fuzzy = true, -- false will disable fuzzy matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = 'smart_case', -- "smart_case", "ignore_case", "respect_case"
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown {},
        },
      },
    }

    -- Optional: Load fzf-native extension if installed
    pcall(require('telescope').load_extension, 'fzf')
    -- Optional: Load ui-select extension if installed
    -- pcall(require('telescope').load_extension, 'ui-select')

    -- >> The Main "Search Everywhere" Keybinding <<
    -- Use a keybinding you prefer. <leader><space> is common.
    -- This example starts with `find_files`. Change `builtin.find_files`
    -- to `builtin.oldfiles` or `builtin.live_grep` etc. if you prefer a different default.
    vim.keymap.set('n', '<leader><space>', function()
      builtin.live_grep() -- Default picker to open
    end, { noremap = true, silent = true, desc = 'Telescope Search Everywhere (Files)' })
    -- See `:help telescope.builtin`
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>fs', builtin.builtin, { desc = '[F]ind [S]elect Telescope' })
    vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
    vim.keymap.set('n', '<leader>fR', builtin.registers, { desc = '[F]ind [R]egisters' })
    vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = '[F]ind [R]esume' })
    vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader>bb', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>f/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[F]ind [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    -- vim.keymap.set('n', '<leader>fn', function()
    -- 	builtin.find_files { cwd = vim.fn.stdpath 'config' }
    -- end, { desc = '[S]earch [N]eovim files' })
  end,
}
