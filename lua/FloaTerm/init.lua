-- floating_terminal.lua

-- Table to keep track of the current buffer and window handles
-- The values are initialized to -1, indicating an invalid or uninitialized state
local state = {
  -- Buffer handle; -1 means no buffer has been created yet
  buf = -1,
  -- Window handle; -1 means no window has been created yet
  win = -1,
}

-- Utility function to get options with a default fallback
-- opts: Table containing user-provided options
-- name: The key to retrieve from the table
-- default: The default value to use if the key is not found or invalid
local function get_opt(opts, name, default)
  return (opts and type(opts[name]) == "number") and opts[name] or default
end

-- Function to create a floating terminal window
-- opts: Table of user-provided options for the terminal's appearance
local function create_floating_window(opts)
  opts = opts or {}  -- Ensure opts is a table

  -- Set width, height, and position with fallbacks
  local width = get_opt(opts, "width", math.floor(vim.o.columns * 0.8))  -- Default to 80% of screen width
  local height = get_opt(opts, "height", math.floor(vim.o.lines * 0.8))  -- Default to 80% of screen height
  local col = get_opt(opts, "col", math.floor((vim.o.columns - width) / 2))  -- Center horizontally
  local row = get_opt(opts, "row", math.floor((vim.o.lines - height) / 2))  -- Center vertically
  local border = opts.border or "rounded"  -- Default to rounded border

  -- Reuse existing buffer if valid, otherwise create a new one
  local buf
  if vim.api.nvim_buf_is_valid(state.buf) then
    buf = state.buf  -- Use existing buffer
  else
    buf = vim.api.nvim_create_buf(false, true)  -- Create a new scratch buffer
    state.buf = buf  -- Store the buffer handle
  end

  -- Configure and open the window
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",  -- Open relative to the editor window
    width = width,        -- Set width of the floating window
    height = height,      -- Set height of the floating window
    col = col,            -- Position horizontally
    row = row,            -- Position vertically
    style = "minimal",    -- Minimal style for floating windows
    border = border,      -- Set the window border style (e.g., "rounded")
  })
  state.win = win  -- Store the window handle

  -- Check if the buffer is already a terminal, if not, start a terminal
  if vim.bo[buf].buftype ~= "terminal" then
    vim.cmd("terminal")  -- Open terminal in the buffer
  end
  -- Set the focus to the newly created window
  vim.api.nvim_set_current_win(win)
end

-- Toggle function to show/hide the floating terminal window
-- opts: Optional arguments to customize window appearance
local function toggle(opts)
  -- If the window is not valid, create a new floating terminal window
  if not vim.api.nvim_win_is_valid(state.win) then
    create_floating_window(opts)
  else
    -- If the window exists, hide it
    vim.api.nvim_win_hide(state.win)
  end
end

-- Expose the toggle and create functions as part of the module
local M = {
  toggle = toggle,
  create = create_floating_window,
}

-- Create a user-defined command ':FloatingTerminal' to easily invoke the toggle function
-- Allows for optional arguments to customize the floating window
vim.api.nvim_create_user_command("FloatingTerminal", function(params)
  local args = {}
  -- Parse user arguments to customize window options
  for _, v in pairs(params.fargs) do
    local k, val = v:match("^(%w+)=(%d+)$")  -- Match key=value pairs
    if k then
      args[k] = tonumber(val)  -- Convert numeric values to numbers
    end
  end
  -- Call the toggle function with the parsed arguments
  toggle(args)
end, {
  nargs = "*",  -- Accepts any number of arguments
  complete = function(_, line)
    -- Provide autocomplete suggestions for available options
    return { "width=", "height=", "row=", "col=", "border=" }
  end,
})

-- Return the module containing the toggle and create functions for external use
return M
