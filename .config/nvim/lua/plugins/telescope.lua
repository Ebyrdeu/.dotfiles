return {
	'nvim-telescope/telescope.nvim',
	version = '*',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'kyazdani42/nvim-web-devicons',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
	},
	config = function()
		require('telescope').setup({
			defaults = {
				file_ignore_patterns = {
					".cache",
					".idea/",
					".git/",
					".github/",
					"node_modules/",
					".zig-cache/",
				},

			}
		})

		local builtin = require('telescope.builtin')

		vim.keymap.set('n', '<leader><leader>', function()
			builtin.find_files({ hidden = true, disable_devicons = false })
		end, { desc = 'Telescope find files' })

		vim.keymap.set('n', '<leader>sr', builtin.buffers, { desc = 'Telescope buffers' })
		vim.keymap.set('n', '<leader>sf', builtin.live_grep, { desc = 'Telescope live grep' })
	end
}
