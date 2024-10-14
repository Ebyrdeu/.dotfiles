return {
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false, -- load at start
		priority = 1000, -- load first
		config = function()
			require("gruvbox").setup({
				contrast = "soft"
			})
			vim.o.background = 'light'
			vim.cmd("colorscheme gruvbox")
		end
	}
}
