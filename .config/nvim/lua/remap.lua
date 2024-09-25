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

-- close buffer
vim.keymap.set('', '<leader>q', '<cmd>bd<cr>')

-- search buffers
vim.keymap.set('n', '<leader>sr', '<cmd>Buffers<cr>')

-- Window Managment
-- Splits / Unsplits
vim.keymap.set('n', '<leader>wv', '<C-w>v<cr>')
vim.keymap.set('n', '<leader>ws', '<C-w>s<cr>')
vim.keymap.set('n', '<leader>ww', '<C-w>w<cr>')
vim.keymap.set('n', '<leader>wu', '<C-w>c<cr>')
vim.keymap.set('n', '<leader>wo', '<C-w>o<cr>')

-- make missing : less annoying
vim.keymap.set('n', ';', ':')

-- Ctrl+l to stop searching
vim.keymap.set('v', '<C-l>', '<cmd>nohlsearch<cr>')
vim.keymap.set('n', '<C-l>', '<cmd>nohlsearch<cr>')

-- Jump to start and end of line using the home row keys
vim.keymap.set('', 'H', '^')
vim.keymap.set('', 'L', '$')

vim.keymap.set('n', '<leader>y', '"+yy')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>Y', '"+yg_')
vim.keymap.set('n', '<leader>gy', '"+ygg')
vim.keymap.set('n', '<leader>pp', '"+p')

-- neat chmod
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

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
vim.keymap.set('n', '<leader>ne', ':e <C-R>=expand("%:p:h") . "/" <cr>')

-- let the left and right arrows be useful: they can switch buffers
vim.keymap.set('n', '<Tab>', ':bp<cr>')
vim.keymap.set('n', '<C-Tab>', ':bn<cr>')

-- make j and k move by visual line, not actual line, when text is soft-wrapped
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-------------------------------------------------------------------------------
--
-- plugins hotkeys
--
----------------------------------------------------------------

-- Leap
vim.keymap.set('n', 's', '<Plug>(leap)')
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
