" enables syntax highlighting
syntax on

" Better colors
set termguicolors

" always yank to clipboard
set clipboard=unnamedplus

" number of spaces in a <Tab>
set tabstop=4
set softtabstop=4
set expandtab

set wrap

" enable autoindents
set smartindent

" number of spaces used for autoindents
set shiftwidth=4

" adds line numbers
set number
set relativenumber

" columns used for the line number
set numberwidth=4

" highlights the matched text pattern when searching
set incsearch
set nohlsearch

" open splits intuitively
set splitbelow
set splitright

" navigate buffers without losing unsaved work
set hidden

" start scrolling when 8 lines from top or bottom
set scrolloff=8

" Save undo history
set undofile

" Enable mouse support
set mouse=a

" case insensitive search unless capital letters are used
set ignorecase
set smartcase

set confirm

let mapleader = ","

lua require('plugins')
