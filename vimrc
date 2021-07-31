" joke's on you, this is a neovim config

call plug#begin('~/.local/share/nvim/plugged')

" Functional
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'ctrlpvim/ctrlp.vim' " <-- to support vim-go tags

" Lang support
Plug 'fatih/vim-go'
Plug 'pangloss/vim-javascript'
Plug 'plasticboy/vim-markdown'

" Superficial
Plug 'flazz/vim-colorschemes'
Plug 'itchyny/lightline.vim'
Plug 'junegunn/vim-emoji'

call plug#end()

" General
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent
set autoread
set autowrite
set autowriteall
set background=dark
set clipboard^=unnamed,unnamedplus
set colorcolumn=100
set completeopt-=preview
set cursorline
set encoding=utf-8
set expandtab
set formatoptions=tcqronj
set history=200
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set lazyredraw
set list
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set magic
set modeline
set nocompatible
set noshowmode
set nospell
set noswapfile
set nowrap
set noerrorbells
set novisualbell
set number
set relativenumber
set ruler
set shiftwidth=2
set smartcase
set smartindent
set smarttab
set softtabstop=2
set splitbelow
set splitright
set tabstop=2
set timeoutlen=50
set title
set updatetime=100
set wildignore=*.o,*~,*.pyc
set wildmenu

syntax enable
let g:netrw_winsize = 75
let mapleader = ','

if has('nvim') " Don't forget to pip3 install -U neovim
    let g:python_host_prog = '/usr/bin/python'
    let g:python3_host_prog = '/usr/local/bin/python3.9'
endif

" split formatting
set fillchars+= "space here intentionally
hi StatusLineNC ctermfg=0 ctermbg=0
hi VertSplit ctermfg=0 ctermbg=0

" Keybind Re-mapping
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map j gj
map k gk
map 0 ^
map <space> /
map <F5> :!start /min ctags -R .<cr>

nnoremap <C-space> za

nnoremap <C-t> :tabnew<CR>:E<CR>
nnoremap <C-x> :tabclose<CR>

set pastetoggle=<F2>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Quick center
nnoremap <space> zz

" Center search results as they're selected
nnoremap n nzzzv
nnoremap N Nzzzv

" Disable arrows for use with buffer nav
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
nnoremap <S-Left> :bprevious<cr>
nnoremap <S-Right> :bnext<cr>

" Splits
nnoremap <leader>v :vsplit<cr>
nnoremap <leader>h :split<cr>
nnoremap <leader>q :close<cr>


" Automation
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" finding files
set path+=**

" Autosave buffers when leaving them
autocmd BufLeave * silent! :wa

" Open bin files in hexedit
augroup Binary
au!
au BufReadPre  *.bin let &bin=1
au BufReadPost *.bin if &bin | %!xxd
au BufReadPost *.bin set ft=xxd | endif
au BufWritePre *.bin if &bin | %!xxd -r
au BufWritePre *.bin endif
au BufWritePost *.bin if &bin | %!xxd
au BufWritePost *.bin set nomod | endif
augroup END

" Delete all trailing whitespace on save
autocmd BufWritePre * :%s/]s]+$//e

" Auto generate ctags
command! MakeTags !ctags -R .

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL

" Skip quickfix when switching buffers with shift + arrows
augroup qf
    autocmd!
    autocmd FileType qf set nobuflisted
augroup END

" Plugins
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ALE
let g:ale_completion_enabled = 1
set omnifunc=ale#completionOmniFunc

" CtrlP [ DISABLED ]
let g:ctrlp_map = ''

" vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_toc_autofit = 1

" vim-emoji
set completefunc=emoji#complete

" Colors
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("termguicolors")
    set termguicolors
endif
colorscheme molokai_dark

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language-Specific Options
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Go
au FileType go set noexpandtab
au FileType go set shiftwidth=4
au FileType go set softtabstop=4
au FileType go set tabstop=4
let g:go_fmt_command = "goimports"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_echo_commandd_info = 1
let g:go_auto_type_info = 1
let g:go_auto_sameids = 1
let g:go_test_show_name = 1
let g:go_gocode_propose_source = 1
let g:go_metalinter_command = 1
let g:go_metalinter_deadline = "5s"
let g:go_metalinter_enabled = [
    \ 'deadcode', 'gas', 'goconst', 'gocyclo', 'golint', 'gosimple',
    \ 'ineffassign', 'vet', 'vetshadow'
\]
let g:go_addtags_transform = "snakecase"

" Bash, CSS, HTML, Javascript, JSON, Make, Protobuf, Ruby, SQL, TOML, YAML
au FileType *.{css,html,js,json,make,protobuf,rb,sh,sql,toml,yml,yaml} set expandtab
au FileType *.{css,html,js,json,make,protobuf,rb,sh,sql,toml,yml,yaml} set shiftwidth=2
au FileType *.{css,html,js,json,make,protobuf,rb,sh,sql,toml,yml,yaml} set softtabstop=2
au FileType *.{css,html,js,json,make,protobuf,rb,sh,sql,toml,yml,yaml} set tabstop=2

" C++, Typescript, vimscript
au FileType *.{cpp,cxx,ts} set expandtab
au FileType *.{cpp,cxx,ts} set shiftwidth=4
au FileType *.{cpp,cxx,ts} set softtabstop=4
au FileType *.{cpp,cxx,ts} set tabstop=4

