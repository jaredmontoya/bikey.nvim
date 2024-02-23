local M = {}

M.input_method_connection_error = function()
  vim.api.nvim_del_augroup_by_name("bikey")
  vim.notify("nvim.bikey was unable to connect to any of the supported input methods.", 3)
end

return M
