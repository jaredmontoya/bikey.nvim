local bikey_group = vim.api.nvim_create_augroup("bikey", { clear = true })

vim.api.nvim_create_autocmd("InsertEnter", {
  group = bikey_group,
  callback = function()
    require("bikey").insert_mode()
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  group = bikey_group,
  callback = function()
    require("bikey").normal_mode()
  end,
})

vim.api.nvim_create_autocmd("FocusGained", {
  group = bikey_group,
  callback = function()
    require("bikey").normal_mode()
  end,
})
