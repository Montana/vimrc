execute pathogen#infect()

filetype off " for linux
syntax on " Set syntax on
filetype on " filetype detection
filetype indent on " filetype indentation
filetype plugin on " filetype plugins

set laststatus=2
set statusline=\ %{HasPaste()}%<%-15.25(%f%)%m%r%h\ %w\ \ 
set statusline+=\ \ \ [%{&ff}/%Y] 
set statusline+=\ \ \ %<%20.30(%{hostname()}:%{CurDir()}%)\ 
set statusline+=%=%-10.(%l,%c%V%)\ %p%%/%L
set rtp+=~/.vim/bundle/Vundle.vim

autocmd! bufwritepost .vimrc source ~/.vimrc

set hlsearch " highlight search

if has("gui_running")	" GUI
    set background=dark
    set guifont=DejaVuSansMonoForPowerline:h13 " font
    set t_Co=256 " 256 bit color in terminal
    set cursorline " show cursor line
    colors codeschool

    " remove scrollbars in MacVim
    set guioptions-=r
    set guioptions-=L
endif

set autoindent " auto indentation
set incsearch " incremental search
set copyindent " copy previous indentation
set expandtab " tab to spaces
set softtabstop=4 " 4 spaces as a tab
set shiftwidth=4
set tabstop=4
set number " line numbers
set wildmenu " autocomplete visual

set laststatus=2 " status line always visible

set clipboard=unnamed " clipboard

" disable error sounds
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" disable auto backup
set nobackup
set nowritebackup
set noswapfile

" Set up CtrlP mappings
let g:ctrlp_map="<c-p>"
let g:ctrlp_cmd="CtrlP"
let g:ctrlp_custom_ignore = 'venv\|node_modules\|DS_Store\|*.pyc' " custom ignore

hi clear SignColumn
hi GitGutterAdd ctermfg=green guifg=darkgreen
hi GitGutterChange ctermfg=yellow guifg=darkyellow
hi GitGutterDelete ctermfg=red guifg=darkred
hi GitGutterChangeDelete ctermfg=yellow guifg=darkyellow

let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#virtualenv#enabled=1
let g:airline#extensions#tabline#fnamemod=':t'

call plug#begin('~/.vim/plugged')
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

let g:jedi#usages_command=""

let g:jedi#use_tabs_not_buffers=0
let g:jedi#popup_on_dot=0
let g:jedi#show_call_signatures="0"
let g:pymode_rope=0

" NERDTreeIgnore
let NERDTreeIgnore=['.*\.pyc$', '^\.git$', '^\.$', '^\.\.$', '^\.sass-cache$', '^__pycache__$']

set foldenable " enable folding
set foldlevelstart=10 " start at max
set foldnestmax=10 " fold max 10
set foldmethod=syntax " fold based on indent

autocmd BufRead,BufNewFile *.css,*.scss,*.less setlocal foldmethod=marker foldmarker={,} " folding for sass

function! NeatFoldText() "{{{2
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
  let foldchar = matchstr(&fillchars, 'fold:\zs.')
  let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()
" }}}2

" Function to create folders when writing
function! s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

" trim white space (http://www.bestofvim.com/tip/trailing-whitespace/)
function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction

" auto clear whitespace
autocmd FileWritePre    * :call TrimWhiteSpace()
autocmd FileAppendPre   * :call TrimWhiteSpace()
autocmd FilterWritePre  * :call TrimWhiteSpace()
autocmd BufWritePre     * :call TrimWhiteSpace()

let mapleader=","

" indent all lines
map <Leader>i <esc>gg=G

" toggle nerdtree
map <Leader>tt <esc>:NERDTreeToggle<CR>

" map pane switching
map <C-h> <C-W>h
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-l> <C-W>l

" tab switching
map <Leader>n :bprevious<CR>
map <Leader>m :bnext<CR>

" remove search highlight
map <Leader>h :nohl<CR>

" fold code
nnoremap <space> za
