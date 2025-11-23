# FloaTerm: Floating Terminal for Neovim

FloaTerm is a Neovim plugin that provides a customizable floating terminal window. This plugin allows you to toggle a floating terminal with ease, configure its appearance, and adjust its position and size based on your preferences.

---

## Features

- **Floating terminal**: Open a terminal in a floating window with flexible width, height, and position.
- **Toggle terminal visibility**: Easily toggle the terminal's visibility with a simple command.
- **Customizable appearance**: Adjust the terminal's border style and size.
- **Command customization**: Pass options to modify the terminal's width, height, position, and more when toggling the terminal.

---

## Installation

### Using `lazy.nvim`

To install and configure FloaTerm using **lazy.nvim**, add the following to your `init.lua` or `plugins.lua` file. You can customize the keybindings and terminal settings as desired:

```lua
{
  "2happy42/FloaTerm",  -- GitHub repository path for the plugin
  version = "*",  -- Use the latest stable version
  event = "VeryLazy",  -- Define when the plugin should be loaded (e.g., on Neovim startup or on demand)
  keys = {
    -- Keybinding for toggling the floating terminal
    {
      "<leader>ft",  -- Keybinding to toggle the floating terminal
      mode = { "n", "v" },
      "<cmd>FloatingTerminal<cr>",  -- Command to trigger the floating terminal
      desc = "Toggle the floating terminal",  -- Description of the keybinding
    },
    {
      "<leader>fT",  -- Another keybinding for opening with specific dimensions
      mode = { "n", "v" },
      "<cmd>FloatingTerminal width=100 height=20<cr>",  -- Open with custom width and height
      desc = "Open floating terminal with custom dimensions",
    },
  },
  opts = {
    -- Default configuration for the floating terminal
    width = 0.8,  -- Width as a percentage of the screen width (default 80%)
    height = 0.8,  -- Height as a percentage of the screen height (default 80%)
    row = 0.1,  -- Row position (default 10% from the top)
    col = 0.1,  -- Column position (default 10% from the left)
    border = "rounded",  -- Border style (default 'rounded')
  },
  config = function(_, opts)
    -- Apply the configuration options
    vim.g.floating_terminal_width = opts.width or 0.8
    vim.g.floating_terminal_height = opts.height or 0.8
    vim.g.floating_terminal_border = opts.border or "rounded"
    vim.g.floating_terminal_row = opts.row or 0.1
    vim.g.floating_terminal_col = opts.col or 0.1

    require("FloaTerm.floating_terminal")
  end,
}
```
---

## Example Usage
Once the plugin is installed and configured, you can use the following command to open or toggle the floating terminal window:
```vim
:FloatingTerminal
```

### Customizing the Floating Terminal
You can customize the floating terminal window's appearance and position by passing the following options when calling :FloatingTerminal:
```vim
:FloatingTerminal width=100 height=20 row=10 col=10 border=rounded
```
- **width**: Set the width of the floating terminal window (in columns).
- **height**: Set the height of the floating terminal window (in lines).
- **row**: Set the row position (distance from the top).
- **col**: Set the column position (distance from the left).
- **border**: Choose the border style (e.g., **rounded**, **none**, etc.).
---

## How It Works
FloaTerm leverages Neovim's built-in terminal functionality and floating window API to open a terminal in a floating window. The terminal window can be toggled on and off with the **:FloatingTerminal** command.
### Key Configuration Options
- **Width/Height**: Set the percentage of your screen that the floating terminal should occupy. The defaults are set to 80% of the screen width and height, but you can customize this as needed.
- **Position (row/col)**: Adjust the terminal's position by setting the **row** and **col** values. These represent the vertical and horizontal offsets as a percentage of your screen dimensions.
- **Border Style**: Choose from different border styles, including **rounded**, **none**, or **single**.
---

## Development and Contributions
If you’d like to contribute to the development of FloaTerm, please feel free to open issues and submit pull requests. Contributions are always welcome!
