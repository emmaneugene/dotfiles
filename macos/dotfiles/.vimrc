set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set exrc
set guicursor=
set nu
set relativenumber
set nohlsearch
set hidden
set noerrorbells
set nowrap
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set scrolloff=8
set signcolumn=yes
set colorcolumn=80,120

" Filetype detection, plugins, and indent rules
filetype plugin indent on

" Syntax highlighting
syntax on

" Spell check and line wrap just for git commit messages
autocmd Filetype gitcommit setlocal spell textwidth=72
