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

-- Jump to last cursor position on file open
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      if not vim.bo[ev.buf].filetype:find("git") then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end
  end,
})

-- Read-only files
vim.api.nvim_create_autocmd("BufRead", {
  pattern = { "*.orig", "*.pacnew" },
  callback = function()
    vim.bo.readonly = true
  end,
})

-- Leave paste mode on insert exit
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.opt.paste = false
  end,
})

-- Text & Document Formatting
local text_group = vim.api.nvim_create_augroup("TextSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = text_group,
  pattern = { "text", "markdown", "mail", "gitcommit" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 72
    vim.opt_local.colorcolumn = "73"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = text_group,
  pattern = "tex",
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.textwidth = 80
    vim.opt_local.colorcolumn = "81"
  end,
})
