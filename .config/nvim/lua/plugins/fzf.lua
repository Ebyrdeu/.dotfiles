return {
	'junegunn/fzf.vim',
	dependencies = {
		{ 'junegunn/fzf', build = './install --all' },
	},
	config = function()
		-- Simple layout
		vim.g.fzf_layout = { down = '~20%' }

		-- Get the initial working directory (root folder)
		local root_dir = vim.fn.getcwd()

		-- List command using fd and removing the root path
		function list_cmd()
			-- fd command to find all files in the root directory
			local fd_cmd = string.format('fd --type file --follow . %s', vim.fn.shellescape(root_dir))

			-- Use sed to remove the root directory from the output
			local sed_cmd = string.format("sed 's|^%s/||'", vim.fn.escape(root_dir, '/'))

			-- Combine fd and sed commands
			return fd_cmd .. " | " .. sed_cmd
		end

		-- Override the Files command
		vim.api.nvim_create_user_command('Files', function(arg)
			vim.fn['fzf#vim#files'](arg.qargs, { source = list_cmd(), options = '--tiebreak=index' },
				arg.bang)
		end, { bang = true, nargs = '?', complete = "dir" })
	end
}
