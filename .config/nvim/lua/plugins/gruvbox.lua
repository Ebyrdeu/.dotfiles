return {
	'sainnhe/gruvbox-material',
	lazy = false,
	priority = 1000,
	config = function()
		vim.o.background = 'light'
		vim.g.gruvbox_material_enable_italic = false
		vim.g.gruvbox_material_background = 'soft'
		vim.cmd.colorscheme('gruvbox-material')
	end
}
