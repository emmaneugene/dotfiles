" A zero-dependency vim configuration

set clipboard=unnamed
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
set colorcolumn=80,100

" Hold shift + arrow keys to select in any mode
nmap <S-Up> v<Up>
nmap <S-Down> v<Down>
nmap <S-Left> v<Left>
nmap <S-Right> v<Right>
vmap <S-Up> <Up>
vmap <S-Down> <Down>
vmap <S-Left> <Left>
vmap <S-Right> <Right>
imap <S-Up> <Esc>v<Up>
imap <S-Down> <Esc>v<Down>
imap <S-Left> <Esc>v<Left>
imap <S-Right> <Esc>v<Right>

let g:VM_maps = {}
let g:VM_maps["Goto Next"] = ''
let g:VM_maps["Goto Prev"] = ''

" Filetype detection, plugins, and indent rules
filetype plugin indent on

" Syntax highlighting
syntax on

" Spell check and line wrap just for git commit messages
autocmd Filetype gitcommit setlocal spell textwidth=72

" Custom cursor on different modes
let &t_EI = "\e[2 q" " Block when exiting insert
let &t_SR = "\e[4 q" " Horizontal line when entering replace
let &t_SI = "\e[6 q" " Vertical line when entering insert
autocmd VimLeave * silent !echo -ne "\e[2 q" " Reset to block on quit
