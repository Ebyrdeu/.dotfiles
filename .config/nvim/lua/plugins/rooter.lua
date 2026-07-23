vim.pack.add({
  { src = git("notjedi/nvim-rooter.lua.git") },
})

require("nvim-rooter").setup()
