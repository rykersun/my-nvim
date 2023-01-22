set nu
set rnu

set ts=4
set et

set sw=4
set sr

set sts=4

set ai
set si
set ci

set tgc
set cursorline
syntax on

set acd

set encoding=utf8
set fileencodings=utf8

set laststatus=2
set backspace=2

set hlsearch
set incsearch

inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {}<Esc>i
inoremap ' ''<Esc>i
inoremap " ""<Esc>i
inoremap < <><Esc>i

let mapleader=" "

nmap <leader>w <C-w>
nmap L :bn<CR>
nmap H :bp<CR>
nmap <leader>c :bd<CR>
