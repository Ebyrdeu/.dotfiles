return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	dependencies = { 'nvim-lua/plenary.nvim' },

	config = function()
		require('telescope').setup({
			defaults = {
				file_ignore_patterns = { 'node_modules', '.git/', '.idea/', '.vscode/' },
			}
		})

		local builtin = require('telescope.builtin')

		-- Corespading to .ideavimrc
		vim.keymap.set('n', '<leader><leader>', function()
			builtin.find_files({ hidden = true})
		end, { desc = 'Telescope find files' })

		vim.keymap.set('n', '<leader>sr', builtin.buffers, { desc = 'Telescope buffers' })
		vim.keymap.set('n', '<leader>sf', builtin.live_grep, { desc = 'Telescope live grep' })
	end
}
