vim.pack.add({
	{
		src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',
		version = vim.version.range('3')
	},
	-- dependencies
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	-- optional, but recommended
	"https://github.com/nvim-tree/nvim-web-devicons",
})


require('neo-tree').setup({
	filesystem = {
		filtered_items = {
			visible = true,
			show_hidden_count = true,
			hide_dotfiles = false,
			hide_by_name = {
				-- add extension names you want to explicitly exclude
				-- '.git',
				-- '.DS_Store',
				-- 'thumbs.db',
			},
			never_show = {},
		},
	},
})
