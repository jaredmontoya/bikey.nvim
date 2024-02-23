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
    normal_mode = function()
      ---@diagnostic disable-next-line: undefined-field, need-check-nil
      last_keyboard_layout = dbus:getLayout()
      ---@diagnostic disable-next-line: undefined-field, need-check-nil
      dbus:setLayout(0)
    end,
    insert_mode = function()
      ---@diagnostic disable-next-line: undefined-field, need-check-nil
      dbus:setLayout(last_keyboard_layout)
    end,
  },
  gnome = {
    connection = {
      bus = dbus_proxy.Bus.SESSION,
      name = "org.gnome.Shell",
      interface = "org.gnome.Shell",
      path = "/org/gnome/Shell",
    },
    normal_mode = function()
      ---@diagnostic disable-next-line: undefined-field, need-check-nil
      last_keyboard_layout = dbus:getLayout()
      ---@diagnostic disable-next-line: undefined-field, need-check-nil
      dbus:Eval("imports.ui.status.keyboard." .. "getInputSourceManager().inputSources" .. "[0].activate()")
    end,
    insert_mode = function()
      ---@diagnostic disable-next-line: undefined-field, need-check-nil
      dbus:Eval(
        "imports.ui.status.keyboard."
          .. "getInputSourceManager().inputSources"
          .. "["
          .. last_keyboard_layout
          .. "].activate()"
      )
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

  M.normal_mode = function() end
  M.insert_mode = function() end
else
  dbus = dbus_proxy.Proxy:new(input_methods[input_method].connection)

  M.normal_mode = input_methods[input_method].normal_mode
  M.insert_mode = input_methods[input_method].insert_mode
end

return M
