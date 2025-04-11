local M = {}

local MAX_LOCATIONS = 100 -- Maximum number of edit locations to store

-- Stores locations as { buf = bufnr, lnum = lnum, col = col, timestamp = ts }
-- lnum is 1-based, col is 0-based (like nvim_win_get_cursor)
M.locations = {}
-- Index of the *currently viewed* location in M.locations after a jump.
-- nil if the user hasn't navigated yet or made a new edit after navigating.
M.current_index = nil
M.config = {} -- To store user config

local function is_valid_location(loc)
  if not loc or not loc.buf or not loc.lnum or loc.col == nil then
    return false
  end
  -- Check if buffer is still valid and loaded
  return vim.api.nvim_buf_is_valid(loc.buf) and vim.api.nvim_buf_is_loaded(loc.buf)
end

-- Record the current cursor position as an edit location
function M.record_location()
  local current_buf = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0) -- {1-based lnum, 0-based col}
  local lnum = cursor[1]
  local col = cursor[2]
  local timestamp = vim.loop.hrtime() -- High-resolution time for sequencing

  local last_loc = M.locations[#M.locations]

  -- Simple Debounce: If the last recorded location is on the same line in the same buffer,
  -- just update its timestamp and column instead of adding a new entry.
  if last_loc and last_loc.buf == current_buf and last_loc.lnum == lnum then
    last_loc.col = col
    last_loc.timestamp = timestamp
    -- print("Updated last edit location") -- Debug
  else
    -- Add new location
    table.insert(M.locations, { buf = current_buf, lnum = lnum, col = col, timestamp = timestamp })
    -- print("Added new edit location: buf", current_buf, "lnum", lnum) -- Debug

    -- Limit history size
    if #M.locations > (M.config.max_locations or MAX_LOCATIONS) then
      table.remove(M.locations, 1) -- Remove the oldest entry
    end
  end

  -- Any new edit resets the navigation index, as the history has diverged
  -- from the navigated state.
  M.current_index = nil
end

-- Jump to a previous or next edit location
-- direction: -1 for previous, 1 for next
function M.jump(direction)
  if #M.locations == 0 then
    vim.notify('LastEditLocation: No edit locations recorded.', vim.log.levels.WARN)
    return
  end

  local target_index

  if M.current_index == nil then
    -- If not currently navigating, start from the end for prev, or conceptual beginning for next
    target_index = (direction == -1) and #M.locations or 1
  else
    target_index = M.current_index + direction
  end

  -- Clamp index within bounds and find the nearest valid location
  local found_valid = false
  while target_index >= 1 and target_index <= #M.locations do
    if is_valid_location(M.locations[target_index]) then
      found_valid = true
      break
    else
      -- Skip invalid location (e.g., buffer closed)
      vim.notify(
        string.format('LastEditLocation: Skipping invalid location at index %d (Buffer %d)', target_index, M.locations[target_index].buf),
        vim.log.levels.DEBUG
      )
      target_index = target_index + direction -- Continue searching in the same direction
    end
  end

  if not found_valid then
    vim.notify(string.format('LastEditLocation: No %s valid locations found.', direction == -1 and 'previous' or 'next'), vim.log.levels.WARN)
    -- Optional: Maybe reset current_index if we hit the boundary?
    -- M.current_index = (direction == -1) and 1 or #M.locations
    return
  end

  M.current_index = target_index -- Update the current navigation index

  local loc = M.locations[M.current_index]

  -- Go to buffer if needed
  if vim.api.nvim_get_current_buf() ~= loc.buf then
    pcall(vim.api.nvim_set_current_buf, loc.buf)
    -- Error handled by is_valid_location check mostly, but pcall is safe
  end

  -- Go to position
  pcall(vim.api.nvim_win_set_cursor, 0, { loc.lnum, loc.col })
  vim.cmd 'normal! zz' -- Center the line vertically

  vim.notify(string.format('LastEditLocation: Jumped to %d/%d', M.current_index, #M.locations), vim.log.levels.INFO, { M })
end

return M
