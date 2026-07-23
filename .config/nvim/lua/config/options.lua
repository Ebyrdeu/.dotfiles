local opt = vim.opt

-- Folding
opt.foldenable = false
opt.foldmethod = "manual"
opt.foldlevelstart = 99

-- View & Interface
opt.scrolloff = 2
opt.wrap = false
opt.signcolumn = "yes"
opt.number = true
opt.relativenumber = true
opt.colorcolumn = "80"

-- Window Splits
opt.splitright = true
opt.splitbelow = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Tabs & Indentation
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.expandtab = false

-- Completion & Wildmenu
opt.wildmode = "list:longest"
opt.wildignore = ".hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site"

-- Misc Options
opt.undofile = true
opt.vb = true
opt.listchars = "tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•"

-- Diff Settings
opt.diffopt:append({ "iwhite", "algorithm:histogram", "indent-heuristic" })

-- Autocommands
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  command = "setlocal colorcolumn=100",
})
