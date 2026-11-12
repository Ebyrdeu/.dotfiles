-- LSP Keymaps (Buffer-local when LSP attaches)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(e)
    local opts = { buffer = e.buf }

    vim.keymap.set("n", "<leader>j", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>en", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "<leader>ep", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>cc", vim.lsp.buf.format, opts)
  end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.hl.on_yank({ timeout = 500 })
  end,
})

