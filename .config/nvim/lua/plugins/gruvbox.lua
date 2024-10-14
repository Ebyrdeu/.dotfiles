return {
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false, -- load at start
		priority = 1000, -- load first
		config = function()
			require("gruvbox").setup({
				contrast = "medium"
			})
			vim.o.background = 'dark'
			vim.cmd("colorscheme gruvbox")
		end
	}
}
