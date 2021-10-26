call plug#begin('~/.vim/plugged')

Plug 'rktjmp/lush.nvim'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'kdheepak/tabline.nvim'
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'https://gitlab.com/yorickpeterse/nvim-window.git'

call plug#end()

lua require('tabline').setup()
lua require('lualine').setup()
lua require('nvim-web-devicons').setup()

set encoding=UTF-8
set background=dark
colorscheme gruvbox

" Keybindings
let mapleader = "-"
nnoremap <leader>ga :!git add %<cr>
nnoremap <leader>gc :!git commit<cr>
nnoremap <leader>gp :!git push<cr>
nnoremap <leader>C <cmd>CHADopen<cr>
nnoremap <leader>ev <cmd>badd ~/.config/nvim/init.vim<cr><cmd>b init.vim<cr>
nnoremap <silent> <leader>w :lua require('nvim-window').pick()<CR>

" Syntax Highlighting
syntax on

" Tab settings
set shiftwidth=2
set tabstop=2
set expandtab

" Indent Settings
set autoindent
set smartindent
filetype plugin indent on

" General Environment Settings
set showcmd " Show active command in lower right corner
set mouse=n " Enable Mouse Mode
set relativenumber " Show relative line numbers in files


