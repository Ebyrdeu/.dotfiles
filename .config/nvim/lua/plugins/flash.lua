vim.pack.add({
  { src = git("folke/flash.nvim.git") },
})

local flash = require("flash")

vim.keymap.set({ "n", "x", "o" }, "s", function()
  flash.jump()
end, { desc = "Flash" })
