vim.pack.add({
  { src = git("windwp/nvim-autopairs.git") },
})

vim.api.nvim_create_autocmd("InsertEnter", {
  once = true,
  callback = function()
    require("nvim-autopairs").setup({})
  end,
})
