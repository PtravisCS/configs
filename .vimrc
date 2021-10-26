
" Syntax Highlighting
syntax on

" Tab settings
set shiftwidth=2
set tabstop=2
set autoindent
set smartindent
set expandtab

" Automatically open new splits to the right and bottom respectively
" set splitright
set splitbelow

" Allows auto-indent
filetype plugin indent on

" Keybindings
let mapleader = "-"
nnoremap <leader>ev :tabe $MYVIMRC<cr>
nnoremap <leader>mk :!./.mkbuild<cr>
nnoremap <leader>ga :!git add %<cr>
nnoremap <leader>gc :!git commit<cr>
nnoremap <leader>gp :!git push<cr>

