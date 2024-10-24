# ⌨️ bikey.nvim

![Github top language](https://img.shields.io/github/languages/top/jaredmontoya/bikey.nvim?style=for-the-badge&logo=lua&color=darkblue)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/jaredmontoya/bikey.nvim?style=for-the-badge)

[bikey.nvim](https://github.com/jaredmontoya/bikey.nvim) is a [Neovim](https://neovim.io) plugin for people who got tired of switching to a latin keyboard layout and back each time they exit and enter insert mode.

It works by ensuring that your first keyboard layout is selected in normal mode and switching to the last keyboard layout that you used in insert mode when you enter insert mode again. Yout first keyboard layout in the list of keyboard layouts must be a latin keyboard layout that you prefer to use in normal mode(Ex: English) for this plugin to be useful.

[demo.webm](https://github.com/jaredmontoya/bikey.nvim/assets/49511278/92ef1466-4544-4329-bb80-4bf17ff6b914)

## 🔌 Supported input methods

- kde

## 📦 Installation

```lua
-- Lazy
{
  "vhyrro/luarocks.nvim",
    dependencies = {
      "rcarriga/nvim-notify", -- Optional dependency
    },
    opts = {
      rocks = { "dbus_proxy" } -- LuaRocks packages to install
    }
},
{
  "jaredmontoya/bikey.nvim",
    event = "VeryLazy",
    dependencies = {
      "vhyrro/luarocks.nvim"
    }
}

-- Packer
use({
  "jaredmontoya/bikey.nvim",
    rocks = { 'dbus_proxy' }
})
```

## 📝 Requirements

- Neovim >= **0.10** ([Lazy](https://github.com/folke/lazy.nvim) + [luarocks](https://github.com/camspiers/luarocks))
- Neovim >= **0.9** ([Packer](https://github.com/wbthomason/packer.nvim) or [Lazy](https://github.com/folke/lazy.nvim) + [nvim_rocks](https://github.com/theHamsta/nvim_rocks))
- gobject introspection runtime
  - Arch
    - ```sh
      pacman -S gobject-introspection-runtime
      ```
  - Ubuntu
    - ```sh
      apt install libgirepository1.0-dev
      ```
