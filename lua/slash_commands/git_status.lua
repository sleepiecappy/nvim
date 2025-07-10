local function get_git_status()
  local cmd = 'git status --porcelain'
  local handle = io.popen(cmd)

  if not handle then
    return nil, 'Failed to execute git status'
  end

  local result = handle:read '*a'
  local success = handle:close()

  if not success then
    return nil, 'Git status command failed'
  end

  return result
end

-- Parse git status into structured data
local function parse_git_status()
  local status_output = get_git_status()
  if not status_output then
    return nil
  end

  local files = {}
  local status_map = {
    ['M '] = 'modified',
    ['A '] = 'added',
    ['D '] = 'deleted',
    ['R '] = 'renamed',
    ['C '] = 'copied',
    ['??'] = 'untracked',
    [' M'] = 'modified_unstaged',
    [' D'] = 'deleted_unstaged',
    ['MM'] = 'modified_staged_and_unstaged',
    ['AM'] = 'added_then_modified',
  }

  for line in status_output:gmatch '[^\r\n]+' do
    local status_code = line:sub(1, 2)
    local filename = line:sub(4)

    table.insert(files, {
      status = status_map[status_code] or 'unknown',
      status_code = status_code,
      filename = filename,
      description = string.format('%s: %s', status_map[status_code] or 'unknown', filename),
    })
  end

  return files
end

local function get_friendly_status()
  local files = parse_git_status()
  if not files then
    return 'No git status available'
  end

  if #files == 0 then
    return 'Working directory clean - no changes to commit'
  end

  local result = 'Git Status Summary:\n'
  for _, file in ipairs(files) do
    result = result .. file.description .. '\n'
  end

  return result
end

return {
  callback = function()
    return get_friendly_status()
  end,
}
