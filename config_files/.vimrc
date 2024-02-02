" Syntax Highlighting
syntax on

" Tab settings
set shiftwidth=2
set tabstop=2
set autoindent
set smartindent
set title

" Automatically open new splits to the right and bottom respectively
" set splitright
set splitbelow

" Allows auto-indent
filetype plugin indent on

" Keybindings
let mapleader = "-"
nnoremap <leader>ev :tabe $MYVIMRC<cr>
nnoremap <leader>erc <cmd>badd ~/.bashrc<cr><cmd>b .bashrc<cr>
nnoremap <leader>mk :!./.mkbuild<cr>
nnoremap <leader>ga :!git add %<cr>
nnoremap <leader>gc :!git commit<cr>
nnoremap <leader>gp :!git push<cr>
nnoremap <left> :bp<cr>
nnoremap <right> :bn<cr>
nnoremap / /\v

" Map -ev to open init.vim for linux and windows
if has('unix')
  nnoremap <leader>ev <cmd>badd ~/.config/nvim/init.vim<cr><cmd>b init.vim<cr>
endif

if has('win32') || has('win32unix')
  nnoremap <leader>ev <cmd>badd $HOME\AppData\Local\nvim\init.vim<cr><cmd>b init.vim<cr>
endif
