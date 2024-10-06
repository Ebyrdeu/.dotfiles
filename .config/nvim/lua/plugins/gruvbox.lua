return {
	{
		"sainnhe/gruvbox-material",
		config = function()
			vim.o.background = "dark"
			vim.g.gruvbox_material_background = 'medium'
			vim.g.gruvbox_material_palette = 'original'
			vim.g.gruvbox_material_spell_foreground = 'original'
			vim.cmd("colorscheme gruvbox-material")
		end
	}
}
