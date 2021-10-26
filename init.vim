" Define Plugins
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

" Enable Plugins that require it
lua require('tabline').setup()
lua require('lualine').setup()

set encoding=UTF-8
set background=dark "required for gruvbox
colorscheme gruvbox

" Keybindings
let mapleader = "-"
nnoremap <leader>ga :!git add %<cr>
nnoremap <leader>gc :!git commit<cr>
nnoremap <leader>gp :!git push<cr>
nnoremap <leader>C <cmd>CHADopen<cr>

if has('unix')
  nnoremap <leader>ev <cmd>badd ~/.config/nvim/init.vim<cr><cmd>b init.vim<cr>
endif

if has('win32') || has('win32unix')
  nnoremap <leader>ev <cmd>badd C:\Users\3364324\AppData\Local\nvim\init.vim<cr><cmd>b init.vim<cr>
endif

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


