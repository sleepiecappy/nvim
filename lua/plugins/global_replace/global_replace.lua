local M = {}

function M.run(opts)
  local confirm = opts.confirm ~= false

  vim.ui.input({ prompt = 'Search for: ' }, function(search)
    if not search or search == '' then
      return
    end

    vim.ui.input({ prompt = 'Replace with: ' }, function(replace)
      if replace == nil then
        return
      end

      require('telescope.builtin').grep_string {
        search = search,
        use_regex = false,
        only_sort_text = true,
        disable_coordinates = false,
        path_display = { 'shorten' },
        search_dirs = { vim.fn.getcwd() },
        attach_mappings = function(_, map)
          map('i', '<CR>', function(prompt_bufnr)
            local actions = require 'telescope.actions'
            actions.send_to_qflist(prompt_bufnr)
            actions.open_qflist(prompt_bufnr)

            vim.schedule(function()
              local flag = confirm and 'c' or ''
              local cmd = string.format([[:cfdo %%s/%s/%s/g%s | update | bd]], vim.fn.escape(search, '/\\'), vim.fn.escape(replace, '/\\'), flag)
              vim.cmd(cmd)
            end)
          end)
          return true
        end,
      }
    end)
  end)
end

return M
