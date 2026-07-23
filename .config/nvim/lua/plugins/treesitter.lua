vim.api.nvim_create_autocmd("User", {
  pattern = "PackChanged",
  callback = function(ev)
    if ev.data and ev.data.spec and ev.data.spec.name == "nvim-treesitter" then
      if ev.data.kind == "install" or ev.data.kind == "update" then
        vim.cmd("TSUpdate")
      end
    end
  end,
})

vim.pack.add({
  { src = git("nvim-treesitter/nvim-treesitter.git") },
})
