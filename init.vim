"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')

" Theme Ayu
Plug 'ayu-theme/ayu-vim'

" Coc
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Devicons
Plug 'ryanoasis/vim-devicons'

" fzf binary
Plug 'junegunn/fzf', { 'do': './install --bin' }

" fzf plugin
Plug 'junegunn/fzf.vim'

" Surroundings
Plug 'tpope/vim-surround'

" Repeat Plugin commands using .
Plug 'tpope/vim-repeat'

" Insert pairs automagically
Plug 'jiangmiao/auto-pairs'

" Search visual selection using # and *
Plug 'bronson/vim-visual-star-search'

" Accelerate J/K
Plug 'rhysd/accelerated-jk'

" Comments
Plug 'tpope/vim-commentary'

" Navigation b/w tmux panes & vim splits
Plug 'christoomey/vim-tmux-navigator'

" Markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

" Git wrapper for neovim
Plug 'tpope/vim-fugitive'

" Github extension
Plug 'tpope/vim-rhubarb'

" JavaScript
Plug 'pangloss/vim-javascript'
Plug 'MaxMEllon/vim-jsx-pretty'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable filetype plugins
filetype plugin on

" Set to auto read when a file is changed from the outside
set autoread
au FocusGained,BufEnter * checktime

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = "\<Space>"

" Highlight current line
set cursorline

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases 
set smartcase
" Show matching brackets when text indicator is over them
set showmatch

" Enable syntax highlighting
syntax enable

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set nowb
set noswapfile

" Use spaces instead of tabs
set expandtab

" 2 chars-wide tabs
set shiftwidth=2
let &softtabstop = &shiftwidth
    
" Hybrid line numbers in normal mode
" Absolute line numbers in insert mode & when buffer loses focus
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set number
augroup END

" Split to right & bottom
set splitbelow
set splitright

" Syntax highlighting
syntax on

" Enable true colors 
set termguicolors

" Theme options
let ayucolor="dark"

" Colorscheme
colorscheme ayu

" Give more space for displaying messages.
set cmdheight=2

" Always show the signcolumn & account for 2 signs
set signcolumn=yes:2

" Prompt linting
set updatetime=300

" Open diff in V split
set diffopt+=vertical

" Always show one line above/below the cursor
set scrolloff=1

" TODO
set wildmenu

" Persist undo history
set undofile

" Don't treat certain chars as part of word
set iskeyword-=_

" Possibility to have more than one unsaved buffers
set hidden

" Auto indent new lines
set autoindent

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helpers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Get current mode
let g:currentmode={
      \'n' : 'Normal ',
      \'no' : 'N·Operator Pending ',
      \'v' : 'Visual ',
      \'V' : 'V·Line ',
      \'^V' : 'V·Block ',
      \'s' : 'Select ',
      \'S': 'S·Line ',
      \'^S' : 'S·Block ',
      \'i' : 'Insert ',
      \'R' : 'Replace ',
      \'Rv' : 'V·Replace ',
      \'c' : 'Command ',
      \'cv' : 'Vim Ex ',
      \'ce' : 'Ex ',
      \'r' : 'Prompt ',
      \'rm' : 'More ',
      \'r?' : 'Confirm ',
      \'!' : 'Shell ',
      \'t' : 'Terminal '
      \}

function! ModeCurrent() abort
    let l:modecurrent = mode()
    let l:modelist = toupper(get(g:currentmode, l:modecurrent, 'V·Block '))
    let l:current_status_mode = l:modelist
    return l:current_status_mode
endfunction

" Check modified status
function! CheckMod(modi)
  if a:modi == 1
    hi Modi guifg=#efefef guibg=#212333 gui=bold
    hi Filename guifg=#efefef guibg=#212333
    return expand('%:t').'*'
  else
    hi Modi guifg=#929dcb guibg=#212333
    hi Filename guifg=#929dcb guibg=#212333
    return expand('%:t')
  endif
endfunction

"""""""""""""""""""""""""""""" 
" CI Status (see https://medium.com/subvisual/jobs-and-timers-in-neovim-how-to-watch-your-builds-fail-f18931f2ffb6) {{{{{
"""""""""""""""""""""""""""""" 
function! OnCiStatus(job_id, data, event) dict
  if a:event == "stdout" && a:data[0] != ''
    let g:ci_status = ParseCiStatus(a:data[0])
    call timer_start(30000, 'CiStatus')
  endif
endfunction

function! CiStatus(timer_id)
  let l:callbacks = {
  \ 'on_stdout': function('OnCiStatus'),
  \ }
  call jobstart('hub ci-status', l:callbacks)
endfunction

let s:in_git = system("git rev-parse — git-dir 2> /dev/null")
if s:in_git == 0
  call CiStatus(0)
endif

function! ParseCiStatus(out)
  let l:states = {
  \ 'success': "ci passed",
  \ 'failure': "ci failed",
  \ 'neutral': "ci yet to run",
  \ 'error': "ci errored",
  \ 'cancelled': "ci cancelled",
  \ 'action_required': "ci requires action",
  \ 'pending': "ci running",
  \ 'timed_out': "ci timed out",
  \ 'no status': "no ci",
  \ }
  return l:states[a:out] . ', '
endfunction

"""""""""""""""""""""""""""""" 
" Custom statusline {{{{{
"""""""""""""""""""""""""""""" 

" Statusline colors
highlight Base guibg=#212333 guifg=#212333
highlight Mode guibg=#82aaff guifg=#181824 gui=bold
highlight Git guibg=#292d3e guifg=#929dcb
highlight Ci guibg=green guifg=white

" Active statusline (see: https://irrellia.github.io/blogs/vim-statusline/)
function! ActiveLine()
  let statusline = ""
  let statusline .= "%#Base#"
  " Current mode
  let statusline .= "%#Mode# %{ModeCurrent()}"
  " Current git branch
  let statusline .= "%#Git# %{get(g:, 'coc_git_status', '')} %)"
  " Full path of the file
  let statusline .= "%#Filename# %F "
  " Make the colour highlight normal
  let statusline .= "%#Base#"
  let statusline .= "%="
  " Current modified status and filename
  let statusline .= "%#Modi# %{CheckMod(&modified)} "
  " CI status
  " TODO change color based on status
  let statusline .= "%#Ci# %{get(g:, 'ci_status')} %)"

  return statusline
endfunction

" Inactive statusline
function! InactiveLine()
  " Set empty statusline and colors
  let statusline = ""
  let statusline .= "%#Base#"

  " Full path of the file
  let statusline .= "%#LineCol# %F "

  return statusline
endfunction

"""""""""""""""""""""""""""""" 
" }}}}} Custom statusline
"""""""""""""""""""""""""""""" 

" Change statusline automatically
augroup Statusline
  autocmd!
  autocmd WinEnter,BufEnter * setlocal statusline=%!ActiveLine()
  autocmd WinLeave,BufLeave * setlocal statusline=%!InactiveLine()
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Coc settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)

" Range format
" vmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

" Prettier
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO Move a line of text using ALT+[jk] or Command+[jk] on mac

" Fast saving
nnoremap <leader>w :w!<cr>

" Fast quitting
nnoremap <leader>q :q<cr>

" Exit insert mode
inoremap jk <Esc>

" Manipulate tabs
map <Leader>tn :tabnew<cr>
map <Leader>tc :tabclose<cr>

" Fast file search
nnoremap <C-p> :Files<CR>

" Clear search highlighting
" TODO change mapping
" nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" Copy & paste to clipboard
vnoremap <Leader>y "+y
vnoremap <Leader>d "+d
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P
vnoremap <Leader>p "+p
vnoremap <Leader>P "+P

" Show diff at current position
nmap gs <Plug>(coc-git-chunkinfo)
" Navigate chunks
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" Undo current chunk
nmap <silent> gu :<C-u>CocCommand git.chunkUndo<CR>

" Fast J/K
nmap j <Plug>(accelerated_jk_gj)
nmap k <Plug>(accelerated_jk_gk)

" 0 is easier, ^ is more useful
nnoremap 0 ^
nnoremap ^ 0

" Manage buffers (try different approaches)
nnoremap <leader>b :buffer 
nnoremap gb :ls<CR>:b<Space>
map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => vim-rhubarb
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:github_enterprise_urls = []
