return {
	'itchyny/lightline.vim',
	lazy = false, -- also load at start since it's UI
	config = function()
		-- no need to also show mode in cmd line when we have bar
		vim.o.showmode = false
		vim.g.lightline = {
			active = {
				left = {
					{ 'mode',     'paste' },
					{ 'readonly', 'filename', 'modified' }
				},
				right = {
					{ 'lineinfo' },
					{ 'percent' },
					{ 'fileencoding', 'filetype' }
				},
			},
			component_function = {
				filename = 'LightlineFilename'
			},
		}
		function LightlineFilenameInLua(opts)
			if vim.fn.expand('%:t') == '' then
				return '[No Name]'
			else
				return vim.fn.getreg('%')
			end
		end
	end

}
