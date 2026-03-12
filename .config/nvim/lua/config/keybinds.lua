vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- Disable Space bar (since it's leader)
vim.keymap.set("n", "<Space>", "<Nop>", { silent = true })

-- Escape from insert mode using 'jj'
vim.keymap.set("i", "jj", "<Esc>")

-- Make missing : less annoying
vim.keymap.set("n", ";", ":")

-- Clear search highlighting with Ctrl+l
vim.keymap.set({ "n", "v" }, "<C-l>", "<cmd>nohlsearch<cr>")

-- Center search results
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")
vim.keymap.set("n", "g*", "g*zz")

-- Jump to start/end of line (Home Row)
vim.keymap.set({ "n", "v" }, "H", "^")
vim.keymap.set({ "n", "v" }, "L", "$")

-- Soft wrap movement (j/k move visually)
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

-- Move selected lines up/down (Alt/Option equivalent logic)
vim.keymap.set("v", "C-J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "C-K", ":m '<-2<CR>gv=gv")

-- Tab Navigation (Buffer switching)
vim.keymap.set("n", "<Tab>", "<cmd>bnext<cr>")
vim.keymap.set("n", "<S-Tab>", "<cmd>bprev<cr>")


-- Clipboard Operations (System Clipboard)
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y') -- Copy
vim.keymap.set("n", "<leader>Y", '"+yg_')        -- Copy to end of line
vim.keymap.set("n", "<leader>gy", '"+ygg')       -- Copy whole file (custom)
vim.keymap.set("n", "<leader>pp", '"+p')         -- Paste

-- File Management
vim.keymap.set("n", "<leader>o", vim.cmd.Ex)                             -- File Explorer (Netrw)

vim.keymap.set("n", "<leader>ne", ':e <C-R>=expand("%:p:h") . "/" <cr>') -- New file adjacent
vim.keymap.set("n", "<leader>q", "<cmd>bd<cr>")                          -- Close Buffer

-- Splits
vim.keymap.set("n", "<leader>wv", "<C-w>v") -- Vertical Split
vim.keymap.set("n", "<leader>ws", "<C-w>s") -- Horizontal Split
vim.keymap.set("n", "<leader>ww", "<C-w>w") -- Switch Windows
vim.keymap.set("n", "<leader>wu", "<C-w>c") -- Close Split
vim.keymap.set("n", "<leader>wo", "<C-w>o") -- Close Others (Maximize)

-- Utilities
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true }) -- Make executable
vim.keymap.set("n", "<leader>vrr", "<cmd>source $MYVIMRC<cr>")              -- Reload Config
