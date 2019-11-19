syntax on
filetype plugin indent on

" vim-plug plugin management!!!!!!!!!!!!
call plug#begin('~/.local/share/nvim/plugged')
Plug 'Shougo/deoplete.nvim'
Plug 'flazz/vim-colorschemes'
Plug 'itchyny/lightline.vim'
Plug 'dense-analysis/ale'
call plug#end()
" Use deoplete.
let g:deoplete#enable_at_startup = 1
" Colorscheme!!!!
colorscheme gruvbox

set ai
set autoread
set background=dark
set encoding=utf-8
set expandtab
set history=200
set ignorecase
set laststatus=2
set lazyredraw
set lbr
set magic
set modeline
set nocompatible
set noshowmode
set number
set ruler
set shiftwidth=4
set si
set smartcase
set smarttab
set softtabstop=0
set splitbelow
set splitright
set so=7
set tabstop=4
set timeoutlen=50
set tw=120
set wildignore=*.o,*~,*.pyc
set wildmenu
set wrap

let g:netrw_winsize = 75

" split formatting
set fillchars+= "space here intentionally
hi StatusLineNC ctermfg=0 ctermbg=0
hi VertSplit ctermfg=0 ctermbg=0

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


" finding files:
set path+=**

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
func! DeleteTrailingWS()
exe "normal mz"
%s/\s\+$//ge
exe "normal `z"
endfunc

autocmd BufWrite *.py :call DeleteTrailingWS()
autocmd BufWrite *.coffee :call DeleteTrailingWS()

" Adjust settings for .xml files -- This totally fucks up in neovim
"au FileType xml exe ":silent %!xmllint --format --recover - 2>/dev/null"

" Auto generate ctags
command! MakeTags !ctags -R .

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
