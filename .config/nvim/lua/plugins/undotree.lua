vim.pack.add({
  { src = git("mbbill/undotree") },
})

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle Undotree" })
