local switch = require("bikey.switch")

local M = {}

M.on_insert_enter = switch.on_insert_enter
M.on_insert_leave = switch.on_insert_leave
M.on_focus_gained = switch.on_focus_gained

return M
