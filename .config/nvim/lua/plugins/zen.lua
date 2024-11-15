return {
	"folke/zen-mode.nvim",
	config = function()
		vim.keymap.set("n", "<leader>dz", function()
			require("zen-mode").setup {
				window = {
					width = 100,
					options = {},
					backdrop = 1
				},
				plugins = {
					options = {
						laststatus = 3
					}
				}
			}
			require("zen-mode").toggle()
			vim.wo.wrap = false
			vim.wo.number = true
			vim.wo.rnu = true
		end)
	end
}
