-- Leaders
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set

-- General Fixes & Navigation
map("n", "<Space>", "<Nop>", { silent = true })
map("i", "jj", "<Esc>")
map("n", ";", ":")
map({ "n", "v" }, "<C-l>", "<cmd>nohlsearch<CR>")

-- Center Search Jumps
map("n", "n", "nzz")
map("n", "N", "Nzz")
map("n", "*", "*zz")
map("n", "#", "#zz")
map("n", "g*", "g*zz")

-- Home / End Navigation & Display Line Motion
map({ "n", "v" }, "H", "^")
map({ "n", "v" }, "L", "$")
map("n", "j", "gj")
map("n", "k", "gk")

-- Move Selected Lines Up/Down
map("v", "<C-j>", ":m '>+1<CR>gv=gv")
map("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- Buffer Navigation
map("n", "<Tab>", "<cmd>bnext<CR>")
map("n", "<S-Tab>", "<cmd>bprev<CR>")

-- System Clipboard
map({ "n", "v" }, "<leader>y", '"+y')
map("n", "<leader>Y", '"+yg_')
map("n", "<leader>gy", '"+ygg')
map("n", "<leader>pp", '"+p')

-- File Management
map("n", "<leader>o", vim.cmd.Ex)
map("n", "<leader>ne", ':e <C-R>=expand("%:p:h") . "/"<CR>')
map("n", "<leader>q", "<cmd>bd<CR>")

-- Window Splits
map("n", "<leader>wv", "<C-w>v")
map("n", "<leader>ws", "<C-w>s")
map("n", "<leader>ww", "<C-w>w")
map("n", "<leader>wu", "<C-w>c")
map("n", "<leader>wo", "<C-w>o")

-- Utilities
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
map("n", "<leader>vrr", "<cmd>source $MYVIMRC<CR>")
