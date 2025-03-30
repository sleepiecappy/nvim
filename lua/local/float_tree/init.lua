local M = {}

-- Create a floating window
table.insert(M, {})
local function create_floating_win()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.6)
  local height = math.floor(vim.o.lines * 0.6)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    style = 'minimal',
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, opts)
  return buf, win
end

-- Function to check for .gitignore and create exclude pattern
local function get_gitignore_filter(path)
  local gitignore_path = (path or vim.fn.getcwd()) .. '/.gitignore'
  local exclude_pattern = ''

  local file = io.open(gitignore_path, 'r')
  if file then
    for line in file:lines() do
      if line:match '%S' and not line:match '^#' then
        exclude_pattern = exclude_pattern .. ' --exclude=' .. vim.fn.shellescape(line)
      end
    end
    file:close()
  end

  return exclude_pattern
end

-- Function to get tree output with gitignore filtering
local function get_tree_output(path)
  local exclude_filter = get_gitignore_filter(path)
  local cmd = 'tree -C ' .. exclude_filter .. ' ' .. vim.fn.shellescape(path or vim.fn.getcwd())
  local handle = io.popen(cmd)
  local result = handle:read '*a'
  handle:close()
  return result
end

-- Show tree in popup
function M.show_tree(path)
  local tree_output = get_tree_output(path)
  local buf, win = create_floating_win()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(tree_output, '\n'))

  -- Enable search within popup
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  vim.api.nvim_buf_set_keymap(buf, 'n', '/', '/', { noremap = true, silent = false })
  vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':q<CR>', { noremap = true, silent = true })
end

-- Setup function
function M.setup(args)
  vim.api.nvim_create_user_command('PopupTree', function(opts)
    M.show_tree(opts.args)
  end, { nargs = '?' })
end

return M
-- vibe coded
