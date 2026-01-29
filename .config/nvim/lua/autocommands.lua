
-- idea is keymaps only works when LSP is on
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(e)
		local opts = { buffer = e.buf }
		-- Key mappings for LSP features
		vim.keymap.set("n", "<leader>j", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<leader>en', vim.diagnostic.goto_next, { noremap = true, silent = true })
		vim.keymap.set('n', '<leader>ep', vim.diagnostic.goto_prev, { noremap = true, silent = true })
		vim.keymap.set("n", "<leader>cc", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end
})
