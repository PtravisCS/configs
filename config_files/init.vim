" Define Plugins
call plug#begin('~/.vim/plugged')

Plug 'gruvbox-community/gruvbox'
Plug 'kdheepak/tabline.nvim'
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'https://gitlab.com/yorickpeterse/nvim-window.git'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
" Plug 'https://github.com/moll/vim-bbye'
Plug 'famiu/bufdelete.nvim'

call plug#end()

" Enable Plugins that require it
lua require('tabline').setup()
lua require('lualine').setup()

set encoding=UTF-8

"required for gruvbox
colorscheme gruvbox
set background=dark

lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    custom_captures = {
      -- Highlight the @foo.bar capture group with the "Identifier" highlight group.
      ["foo.bar"] = "Identifier",
    },
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF

lua <<EOF
require'nvim-treesitter.configs'.setup {
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}
EOF

lua <<EOF
require'nvim-treesitter.configs'.setup {
  indent = {
    enable = true
  }
}
EOF

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" Keybindings
let mapleader = "-"
nnoremap <leader>ga :!git add %<cr>
nnoremap <leader>gc :!git commit<cr>
nnoremap <leader>gp :!git push<cr>
nnoremap <leader>C <cmd>CHADopen<cr>
nnoremap :Bd :Bdelete<cr>
nnoremap :Bw :Bwipeout<cr>

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


