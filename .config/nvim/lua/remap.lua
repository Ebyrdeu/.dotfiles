-- always set leader first!
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "

-------------------------------------------------------------------------------
--
-- hotkeys
--
----------------------------------------------------------------

-- quick-open
vim.keymap.set('', '<leader><leader>', '<cmd>Files<cr>')

-- search buffers
vim.keymap.set('n', '<leader>sr', '<cmd>Buffers<cr>')

-- quick-save
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>')

-- make missing : less annoying
vim.keymap.set('n', ';', ':')

-- Ctrl+l to stop searching
vim.keymap.set('v', '<C-l>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<C-l>', '<cmd>nohlsearch<cr>')

-- Jump to start and end of line using the home row keys
vim.keymap.set('', 'H', '^')
vim.keymap.set('', 'L', '$')

-- Neat X clipboard integration
-- <leader>p will paste clipboard into buffer
-- <leader>c will copy entire buffer into clipboard
vim.keymap.set('n', '<leader>p', '<cmd>read !wl-paste<cr>')
vim.keymap.set('n', '<leader>c', '<cmd>w !wl-copy<cr><cr>')

-- <leader>, shows/hides hidden characters
vim.keymap.set('n', '<leader>,', ':set invlist<cr>')

-- always center search results
vim.keymap.set('n', 'n', 'nzz', { silent = true })
vim.keymap.set('n', 'N', 'Nzz', { silent = true })
vim.keymap.set('n', '*', '*zz', { silent = true })
vim.keymap.set('n', '#', '#zz', { silent = true })
vim.keymap.set('n', 'g*', 'g*zz', { silent = true })

-- "very magic" (less escaping needed) regexes by default
vim.keymap.set('n', '?', '?\\v')
vim.keymap.set('n', '/', '/\\v')
vim.keymap.set('c', '%s/', '%sm/')

-- open new file adjacent to current file
vim.keymap.set('n', '<leader>o', ':e <C-R>=expand("%:p:h") . "/" <cr>')

-- let the left and right arrows be useful: they can switch buffers
vim.keymap.set('n', '<Tab>', ':bp<cr>')
vim.keymap.set('n', '<C-Tab>', ':bn<cr>')

-- make j and k move by visual line, not actual line, when text is soft-wrapped
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
