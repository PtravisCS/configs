" Define Plugins
call plug#begin('~/.vim/plugged')

Plug 'gruvbox-community/gruvbox'
Plug 'williamboman/mason.nvim' " Mason Language server package manager
Plug 'neovim/nvim-lspconfig' " Language server config files
Plug 'kdheepak/tabline.nvim'
Plug 'hoob3rt/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'ryanoasis/vim-devicons'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'} " Filetree plugin
Plug 'ms-jpq/coq_nvim', {'branch': 'coq', 'do': ':COQdeps'} " Intelisense autocomplete popup
Plug 'ray-x/lsp_signature.nvim' " Function/method signature/documentation popup
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
Plug 'https://gitlab.com/yorickpeterse/nvim-window.git' " Plugin for quickly jumping between splits (-w)
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'https://github.com/tpope/vim-surround.git'
Plug 'echasnovski/mini.jump2d' " Text jump program (<enter>)
Plug 'https://github.com/moll/vim-bbye' " Allows destroying buffers without closing splits
Plug 'dense-analysis/ale' " Linter
Plug 'nvim-lua/plenary.nvim' " Dependency for telescope.nvim
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' } " Search plugin (-ff, -fg, -fn)
Plug 'catgoose/telescope-helpgrep.nvim'
Plug 'rcarriga/nvim-notify' " Notification box plugin
Plug 'folke/which-key.nvim'
Plug 'sontungexpt/stcursorword' " Highlights other instances of work under cursor in project
Plug 'MeanderingProgrammer/render-markdown.nvim' " Markdown display in terminal
Plug 'lukas-reineke/indent-blankline.nvim' " Indentation guides plugin

call plug#end()

lua <<EOF

-- Enable Plugins that require it
require('tabline').setup()
require('lualine').setup()
require('mini.jump2d').setup()
require('which-key').setup()
require('stcursorword').setup({ highlight = { underline = false, bg = 35 } })
vim.notify = require("notify")
require('mason').setup()
-- require('mason-lspconfig').setup({ automatic_installation = true })
require('render-markdown').setup()
require("ibl").setup()

-- Treesitter Configuration
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true
  }
}

-- Telescope Configuration
require("telescope").setup {
  defaults = {
    preview = { -- Display images using terminal image viewer
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
                'catimg', '-t', filepath  -- Terminal image viewer command
            }, 
            {on_stdout=send_output, stdout_buffered=true, pty=true}
          )
        else
          require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
        end
      end
    },
  },
  extensions = {
    helpgrep = {
      ignore_paths = {
        vim.fn.stdpath("state") .. "/lazy/readme",
      },
    }
  }
}

require('telescope').load_extension('helpgrep')

-- Enable lspconfig method/function signature/docs popup
require'lsp_signature'.setup({
  bind = true,
  max_height = 12,
  wrap = true,
  floating_window = true,
  close_timeout = 500,
  handler_opts = {
    border = "rounded"
  }
})

--Install Language Servers


--Enable Language Servers
--require('lspconfig').bashls.setup{}
--require('lspconfig').intelephense.setup{}
vim.lsp.config("intelephense",{})
vim.lsp.config("lua_ls",{})
vim.lsp.config("vimls",{})
vim.lsp.config("perlnavigator",{})
vim.lsp.config("clangd",{})
vim.lsp.config("awk_ls",{})
vim.lsp.config("cmake",{})
vim.lsp.config("html",{})
-- vim.lsp.config("java_language_server.setup{} --Requires maven and bash to be installed
vim.lsp.config("eslint",{})
vim.lsp.config("jsonls",{})
-- vim.lsp.config("kotlin_language_server",{})
vim.lsp.config("powershell_es",{})
vim.lsp.config("rust_analyzer",{})

EOF

if $TERM_PROGRAM != "Apple_Terminal"
  lua vim.opt.termguicolors = true --required for nvim notify
endif

set encoding=UTF-8
colorscheme gruvbox
set background=dark

" Auto start autocomplete plugin
" Not compatible with Windows sadly
if has('unix')
  let g:coq_settings = { 'auto_start': 'shut-up', 'display.icons.mode': 'long', "keymap.recommended": v:false }

	ino <silent><expr> <Esc> 	pumvisible() ? "\<C-e><Esc>" : "\<Esc>"
	ino <silent><expr> <C-c> 	pumvisible() ? "\<C-e><C-c>" : "\<C-c>"
	ino <silent><expr> <BS> 	pumvisible() ? "\<C-e><BS>" : "\<BS>"
	ino <silent><expr> <CR> 	pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"
	ino <silent><expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
	ino <silent><expr> <Up> 	pumvisible() ? "\<C-p>" : "\<BS>"

endif

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
nnoremap <left> :bp<cr>
nnoremap <right> :bn<cr>
nnoremap / /\v
xnoremap <leader>r :Hypersonic<cr>

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>fhg <cmd>Telescope helpgrep<cr>
nnoremap <leader>fn <cmd>Telescope notify<cr>

" Map -ev to open init.vim for linux and windows
if has('unix')
  nnoremap <leader>ev <cmd>badd ~/.config/nvim/init.vim<cr><cmd>b init.vim<cr>
endif

" If mapping to someplace other than ~/ make sure to set a HOME environment variable
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
set noexpandtab

" Indent Settings
set autoindent
set smartindent
filetype plugin indent on

" General Environment Settings
set showcmd " Show active command in lower right corner
set mouse=n " Enable Mouse Mode
set number " Show line numbers
set relativenumber " Show relative line numbers in files
set title
set diffopt+=iwhite " ignore whitespace at start/end of line in diff mode
setlocal spell spelllang=en_us

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
