" Base Settings
" =========================================

" General Settings
set clipboard=unnamed
set scrolloff=8
set number
set relativenumber
set showcmd
set autoindent
set backspace=indent,eol,start
set hlsearch
set ignorecase
set incsearch
set smartcase

let mapleader = " "

" Plugin Settings
" =========================================
call plug#begin()
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'machakann/vim-highlightedyank'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

" Themes
syntax enable

" Turn Off Sound Error
set belloff=all

" Plugins settings
let g:EasyMotion_do_mapping=0
let g:fzf_action = { 'enter': 'tab split' }

" Key Mapping
" =========================================

" Insert Mode Mapping
inoremap <C-c> <Esc>
nnoremap <C-l> :nohlsearch<CR>

" Easy Motion
nmap s <Plug>(easymotion-s2)
nmap S <Plug>(easymotion-sl2)

" Tab Navigation
nnoremap <Tab> :tabnext<CR>
nnoremap <C-Tab> :tabprev<CR>

" Leader Key Mapping
" =========================================

" Create new File
nnoremap <Leader>ne :enew<CR>

" Update Config - Build <C-S-O>
nnoremap <leader>vrr    :source ~/.vimrc<CR>

" Search
nnoremap <leader><leader> :Files<CR>
nnoremap <Leader>ss /

" Terminal
nnoremap <leader>to :terminal<CR>

" Code Format
nnoremap <leader>cc =mzgg=G`z<CR>

" Close active Tab
nnoremap <leader>q :bd<CR>

" Window Splits
nnoremap <Leader>wv <C-w>v<CR>
nnoremap <Leader>ws <C-w>s<CR>
nnoremap <Leader>ww <C-w>w<CR>
nnoremap <Leader>wu :q<CR>
nnoremap <Leader>wo :wincmd R<CR>
