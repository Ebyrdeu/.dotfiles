local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
		lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins" },
		{
			"sainnhe/gruvbox-material",
			lazy = false,
			priority = 1000,
			config = function()
				vim.g.gruvbox_material_enable_italic = true
				vim.g.gruvbox_material_background = "hard"

				vim.cmd.colorscheme("gruvbox-material")
			end
		}
	},

	install = { colorscheme = { "gruvbox-material" } },
	checker = { enabled = true },
})
