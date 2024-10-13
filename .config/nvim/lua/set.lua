-------------------------------------------------------------------------------
--
-- preferences
--
-------------------------------------------------------------------------------
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#282828' })                 -- Background color
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = '#282828', fg = '#ebdbb2' }) -- Border

-- never ever folding
vim.opt.foldenable = false
vim.opt.foldmethod = 'manual'
vim.opt.foldlevelstart = 99
vim.opt.scrolloff = 8

-- never show me line breaks if they're not there
vim.opt.wrap = false

-- always draw sign column. prevents buffer moving when adding/deleting sign
vim.opt.signcolumn = 'yes'

-- sweet sweet relative line numbers
vim.opt.relativenumber = true

-- and show the absolute line number for the current line
vim.opt.number = true

-- keep current content top + left when splitting
vim.opt.splitright = true
vim.opt.splitbelow = true

-- infinite undo!
-- NOTE: ends up in ~/.local/state/nvim/undo/
vim.opt.undofile = true

--" Decent wildmenu
-- in completion, when there is more than one match,
-- list all matches, and only complete to longest common match
vim.opt.wildmode = 'list:longest'

-- when opening a file with a command (like :e),
-- don't suggest files like there:
vim.opt.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site'

vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.expandtab = false

-- case-insensitive search/replace
vim.opt.ignorecase = true

-- unless uppercase in search term
vim.opt.smartcase = true

-- never ever make my terminal beep
vim.opt.vb = true

-- no swap for once
vim.o.swapfile = false

-- more useful diffs (nvim -d)
--- by ignoring whitespace
vim.opt.diffopt:append('iwhite')

--- and using a smarter algorithm
--- https://vimways.org/2018/the-power-of-diff/
--- https://stackoverflow.com/questions/32365271/whats-the-difference-between-git-diff-patience-and-git-diff-histogram
--- https://luppeng.wordpress.com/2020/10/10/when-to-use-each-of-the-git-diff-algorithms/
vim.opt.diffopt:append('algorithm:histogram')
vim.opt.diffopt:append('indent-heuristic')

-- show a column at 80 characters as a guide for long lines
vim.opt.colorcolumn = '80'

--- except in Rust where the rule is 100 characters
vim.api.nvim_create_autocmd('Filetype', { pattern = 'rust', command = 'set colorcolumn=100' })

-- show more hidden characters
-- also, show tabs nicer
vim.opt.listchars = 'tab:^ ,nbsp:¬,extends:»,precedes:«,trail:•'

vim.api.nvim_set_hl(0, 'LeapBackdrop', { link = 'Comment' })
