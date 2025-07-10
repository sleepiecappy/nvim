return {
  callback = function()
    local function get_staged_diff()
      -- Get list of staged files with their status
      local files_info = {}
      local status_handle = io.popen 'git diff --cached --name-status'
      if status_handle then
        for line in status_handle:lines() do
          local status, filename = line:match '^([AMDRC])\t(.+)$'
          if status and filename then
            table.insert(files_info, { status = status, filename = filename })
          end
        end
        status_handle:close()
      end

      if #files_info == 0 then
        return 'No staged changes'
      end

      -- Build context
      local context = 'COMMIT CONTEXT:\n\n'

      -- Summarize changes
      context = context .. 'FILES BEING COMMITTED:\n'
      for _, file in ipairs(files_info) do
        local action = ({
          A = 'Added',
          M = 'Modified',
          D = 'Deleted',
          R = 'Renamed',
          C = 'Copied',
        })[file.status] or 'Changed'

        context = context .. string.format('  %s: %s\n', action, file.filename)
      end

      -- Get diff but limit size for AI
      local diff_cmd = 'git diff --cached --no-color --unified=3'
      local diff_handle = io.popen(diff_cmd)
      local diff_content = diff_handle and diff_handle:read '*a' or ''
      if diff_handle then
        diff_handle:close()
      end

      -- Truncate if too long (optional)
      local max_diff_length = 5000
      if #diff_content > max_diff_length then
        diff_content = diff_content:sub(1, max_diff_length) .. '\n\n[... diff truncated for brevity ...]'
      end

      context = context .. '\nDETAILED CHANGES:\n' .. diff_content

      return context
    end
    return get_staged_diff()
  end,
}
