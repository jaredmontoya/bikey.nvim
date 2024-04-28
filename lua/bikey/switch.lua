local dbus_proxy = require("dbus_proxy")
local errors = require("bikey.errors")

local M = {}

local dbus = nil

local last_keyboard_layout = 0

local input_methods = {
  kde = {
    connection = {
      bus = dbus_proxy.Bus.SESSION,
      name = "org.kde.keyboard",
      interface = "org.kde.KeyboardLayouts",
      path = "/Layouts",
    },
    on_insert_enter = function()
      ---@diagnostic disable-next-line: undefined-field, need-check-nil
      dbus:setLayout(last_keyboard_layout)
    end,
    on_insert_leave = function()
      ---@diagnostic disable-next-line: undefined-field, need-check-nil
      last_keyboard_layout = dbus:getLayout()
      ---@diagnostic disable-next-line: undefined-field, need-check-nil
      dbus:setLayout(0)
    end,
    on_focus_gained = function()
      local current_mode = vim.api.nvim_get_mode().mode
      if current_mode ~= "i" and current_mode ~= "R" then
        ---@diagnostic disable-next-line: undefined-field, need-check-nil
        dbus:setLayout(0)
      end
    end,
  },
  gnome = {
    connection = {
      bus = dbus_proxy.Bus.SESSION,
      name = "org.gnome.Shell",
      interface = "org.gnome.Shell",
      path = "/org/gnome/Shell",
    },
    on_insert_enter = function()
      ---@diagnostic disable-next-line: undefined-field, need-check-nil
      dbus:Eval(
        "imports.ui.status.keyboard."
          .. "getInputSourceManager().inputSources"
          .. "["
          .. last_keyboard_layout
          .. "].activate()"
      )
    end,
    on_insert_leave = function()
      ---@diagnostic disable-next-line: undefined-field, need-check-nil
      last_keyboard_layout = dbus:getLayout()
      ---@diagnostic disable-next-line: undefined-field, need-check-nil
      dbus:Eval("imports.ui.status.keyboard." .. "getInputSourceManager().inputSources" .. "[0].activate()")
    end,
    on_focus_gained = function()
      local current_mode = vim.api.nvim_get_mode().mode
      if current_mode ~= "i" and current_mode ~= "R" then
        ---@diagnostic disable-next-line: undefined-field, need-check-nil
        dbus:Eval("imports.ui.status.keyboard." .. "getInputSourceManager().inputSources" .. "[0].activate()")
      end
    end,
  },
}

local function get_input_method()
  for backend, cfg in pairs(input_methods) do
    if pcall(function()
      dbus_proxy.Proxy:new(cfg.connection)
    end) then
      dbus_proxy.Proxy:new(cfg.connection)
      return backend
    end
  end
end

local input_method = get_input_method()

if input_method == nil then
  errors.input_method_connection_error()

  M.on_insert_enter = function() end
  M.on_insert_leave = function() end
  M.on_focus_gained = function() end
else
  dbus = dbus_proxy.Proxy:new(input_methods[input_method].connection)

  M.on_insert_enter = input_methods[input_method].on_insert_enter
  M.on_insert_leave = input_methods[input_method].on_insert_leave
  M.on_focus_gained = input_methods[input_method].on_focus_gained
end

return M
