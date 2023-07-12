" Define Plugins
call plug#begin('~/.vim/plugged')

Plug 'gruvbox-community/gruvbox'
Plug 'kdheepak/tabline.nvim'
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'} " Intelisense autocomplete popup
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
Plug 'https://gitlab.com/yorickpeterse/nvim-window.git'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'echasnovski/mini.jump2d'
Plug 'https://github.com/moll/vim-bbye'
Plug 'dense-analysis/ale' " Linter
Plug 'tomiis4/Hypersonic.nvim' " RegEx tester
Plug 'nvim-lua/plenary.nvim' " Dependency for telescope.nvim
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.2' }

call plug#end()

" Enable Plugins that require it
lua require('tabline').setup()
lua require('lualine').setup()
lua require('mini.jump2d').setup()

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

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },

  indent = {
    enable = true
  }
}
EOF

" Auto start autocomplete plugin
let g:coq_settings = { 'auto_start': 'shut-up', 'display.icons.mode': 'long' }

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" Keybindings
let mapleader = "-"
nnoremap <leader>ga :!git add %<cr>
nnoremap <leader>gc :!git commit<cr>
nnoremap <leader>gp :!git push<cr>
nnoremap <leader>erc <cmd>badd ~/.bashrc<cr><cmd>b .bashrc<cr>
nnoremap <leader>C <cmd>CHADopen<cr>
nnoremap <Esc> <C-\><C-n>
nnoremap <left> bp
nnoremap <right> bn
nnoremap / /\v
xnoremap <leader>r :Hypersonic<cr>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Close all files when pressing f4
map <F4> :qa!<CR>

" Map -ev to open init.vim for linux and windows
if has('unix')
  nnoremap <leader>ev <cmd>badd ~/.config/nvim/init.vim<cr><cmd>b init.vim<cr>
endif

if has('win32') || has('win32unix')
  nnoremap <leader>ev <cmd>badd $HOME\AppData\Local\nvim\init.vim<cr><cmd>b init.vim<cr>
endif

" Map -w to open window picker
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
set title

" Linting
call ale#linter#Define('php', {
\ 'name': 'phpcs',
\ 'lsp': 'stdio',
\ 'executable': 'phpcs',
\ 'command': '',
\ 'project_root': '.'
\})

let g:ale_fixers = {
\ 'sql': ['sqlfluff']
\}

" Telescope configuration
lua << EOF
  -- Display images using terminal image viewer
  require("telescope").setup {
    defaults = {
      preview = {
        mime_hook = function(filepath, bufnr, opts)
          local is_image = function(filepath)
            local image_extensions = {'png','jpg'}   -- Supported image formats
            local split_path = vim.split(filepath:lower(), '.', {plain=true})
            local extension = split_path[#split_path]
            return vim.tbl_contains(image_extensions, extension)
          end
          if is_image(filepath) then
            local term = vim.api.nvim_open_term(bufnr, {})
            local function send_output(_, data, _ )
              for _, d in ipairs(data) do
                vim.api.nvim_chan_send(term, d..'\r\n')
              end
            end
            vim.fn.jobstart(
              {
                  'catimg', filepath  -- Terminal image viewer command
              }, 
              {on_stdout=send_output, stdout_buffered=true, pty=true})
          else
            require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
          end
        end
      },
    }
  }
EOF
