return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	dependencies = { 'nvim-lua/plenary.nvim' },

	config = function()
		require('telescope').setup({
			defaults = {
				file_ignore_patterns = { "node_modules", ".git" },
				file_sorter = require("telescope.sorters").get_fuzzy_file,
				generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
				vimgrep_arguments = {
					'rg',
					'--color=never',
					'--no-heading',
					'--with-filename',
					'--line-number',
					'--column',
					'--smart-case',
					'--hidden',
					'--glob=!.git/*',
					'--glob=!node_modules/*',
					'--glob=!.vscode/*',
					'--glob=!.idea/*',
					'-L',
				}
			}
		})

		local builtin = require('telescope.builtin')

		-- Corespading to .ideavimrc
		vim.keymap.set('n', '<leader><leader>', function()
			builtin.find_files({ hidden = true })
		end, { desc = 'Telescope find files' })

		vim.keymap.set('n', '<leader>sr', builtin.buffers, { desc = 'Telescope buffers' })
		vim.keymap.set('n', '<leader>se', builtin.live_grep, { desc = 'Telescope live grep' })
	end
}
