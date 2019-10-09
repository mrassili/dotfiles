"specify a directory for plugins
call plug#begin('~/.local/share/nvim/plugged')

" material color scheme
Plug 'kaicataldo/material.vim'

" Surroundings for code
Plug 'tpope/vim-surround'

" sdrasner night-owl colorscheme"
Plug 'haishanh/night-owl.vim'

" commment/uncomment code
Plug 'tpope/vim-commentary'

" intellisense engine for neovim
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}

" git wrapper
Plug 'tpope/vim-fugitive'

" vue syntax hightlighting
Plug 'posva/vim-vue'

" TOML syntaxx hightlighting
Plug 'cespare/vim-toml'

call plug#end()

if (has("termguicolors"))
 set termguicolors
endif

syntax on
let g:material_terminal_italics = 1
let g:material_theme_style = 'ocean'
colorscheme material
set encoding=UTF-8
set backspace=indent,eol,start
set cursorline " Highlight current line
set expandtab " Expand tabs to spaces
set hlsearch " Highlight searches
set ignorecase " Ignore case of searches
set incsearch " Highlight dynamically as pattern is typed
set nu " Enable line numbers
set nowrap "do not wrap lines
set splitright "open split panes to the right
" map mode switch to jk 
inoremap jk <esc>
set tabstop=2
set shiftwidth=2
set smarttab
inoremap <S-Tab> <C-d>


" leader key
let mapleader = ","

" move lines up and down (fix)
" nnoremap <A-j> :m .+1<CR>==
" nnoremap <A-<Up>> :m .-2<CR>==
" inoremap <A-<Down>> <Esc>:m .+1<CR>==gi
" inoremap <A-<Up>> <Esc>:m .-2<CR>==gi
" vnoremap <A-<Down>> :m '>+1<CR>gv=gv
" vnoremap <A-<Up>> :m '<-2<CR>gv=gv

" add branch to statusline
set statusline+=%{FugitiveStatusline()}
set statusline+=%F

" for coc-prettier to work
command! -nargs=0 Prettier :CocCommand prettier.formatFile
