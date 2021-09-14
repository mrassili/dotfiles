call plug#begin(stdpath('data') . '/plugged')

" language client
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" git wrapper
Plug 'tpope/vim-fugitive'

" fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" colorscheme
Plug 'gruvbox-community/gruvbox'

" surroundings
Plug 'tpope/vim-surround'

" comments
Plug 'tpope/vim-commentary'

" github extension
Plug 'tpope/vim-rhubarb'

" navigation b/w tmux panes & vim splits
Plug 'christoomey/vim-tmux-navigator'

" devicons
Plug 'ryanoasis/vim-devicons'

" search visual selection using # and *
Plug 'bronson/vim-visual-star-search'

" easy motion using 2 chars combo
Plug 'easymotion/vim-easymotion'

" repeat plugin commands
Plug 'tpope/vim-repeat'

" js/jsx support
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'

" manage branches (fugitive ext)
Plug 'idanarye/vim-merginal'
call plug#end()

" gruvbox
let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox

" fzf
nnoremap <C-p> :Files<CR>
command! -bang -nargs=* Rg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -g '!yarn.lock' -g '!package-lock.json' -- ".shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)

" enable filetype plugins
filetype plugin on

" set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" leader
let mapleader = "\<Space>"

" highlight current line
set cursorline

" ignore case when searching
set ignorecase

" when searching try to be smart about cases 
set smartcase
" show matching brackets when text indicator is over them
set showmatch

" enable syntax highlighting
syntax enable

" turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile

" use spaces instead of tabs
set expandtab

" 2 chars-wide tabs
set shiftwidth=2
let &softtabstop = &shiftwidth

" dont wrap long lines
set nowrap
    
" hybrid line numbers in normal mode
" absolute line numbers in insert mode & when buffer loses focus
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set number
augroup END

" split to right & bottom
set splitbelow
set splitright

" syntax highlighting
syntax on

" enable true colors 
set termguicolors

" give more space for displaying messages.
set cmdheight=2

" always show the signcolumn & account for 2 signs
set signcolumn=yes:2

" prompt linting
set updatetime=300

" open diff in V split
set diffopt+=vertical

" always show one line above/below the cursor
set scrolloff=1

" TODO
set wildmenu

" persist undo history
set undofile

" don't treat certain chars as part of word
set iskeyword-=_

" possibility to have more than one unsaved buffers
set hidden

" auto indent new lines
set autoindent

" enable project-specific rc's
set exrc

" Fast saving
nnoremap <leader>w :w!<cr>

" Fast quitting
nnoremap <leader>q :q<cr>

" Exit insert mode
inoremap jk <Esc>

" Manipulate tabs
map <Leader>tn :tabnew<cr>
map <Leader>tc :tabclose<cr>

" Copy & paste to clipboard
vnoremap <Leader>y "+y
vnoremap <Leader>d "+d
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P


" 0 is easier, ^ is more useful
nnoremap 0 ^
nnoremap ^ 0

" keeping it centered
nnoremap n nzzzv
nnoremap N Nzzzv

" Manage buffers (try different approaches)
" nnoremap <leader>b :buffer 
" nnoremap gb :ls<CR>:b<Space>
" map <leader>l :bnext<cr>
" map <leader>h :bprevious<cr>

" coc
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references-used)
" coc-git
nmap gs <Plug>(coc-git-chunkinfo) " show diff at current position
nmap [c <Plug>(coc-git-prevchunk)
nmap ]c <Plug>(coc-git-nextchunk)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
nmap <silent> gu :<C-u>CocCommand git.chunkUndo<CR>
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" git signs
hi! link DiffAdd GruvboxGreenSign
hi! link DiffChange GruvboxAquaSign
hi! link DiffDelete GruvboxRedSign

cabbrev ls list

" easy motion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)
" or
" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap s <Plug>(easymotion-overwin-f2)
" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1
" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" TODO
set secure
