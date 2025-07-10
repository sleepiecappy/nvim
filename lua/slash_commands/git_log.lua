return {
  callback = function()
    local handle = io:popen 'git log --name-only --pretty=format:"Commit: %h | Date: %ad | Author: %an | Message: %s | Files changed:" --date=short -n 10'
    if not handle then
      return nil, 'Failed to execute git command'
    end
    local result = handle:read '*a'
    local closed = handle:close()
    if not closed then
      return nil, 'git command failed to be closed'
    end
    return result
  end,
  description = 'Fetch the 10 most recent commits',
}
