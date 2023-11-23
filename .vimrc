let mapleader = " "

" indent
set ai
set si
set ci
set ts=4
set sw=4

" search
set hls
set incsearch
set smartcase

" text
syntax on
set wrap
set linebreak
set scrolloff=1
set encoding=utf-8
set sidescrolloff=5
set display+=lastline
set guifont=Menlo\ Regular:h18

" display
set number
"set guicursor+=a:blinkon0
set t_Co=256
"set cursorline
set belloff=all
"set laststatus=2
set relativenumber
colorscheme default
set lines=100
set columns=120

" misc
syntax on
filetype plugin on
set cb=unnamed
set noswapfile
set nocompatible
set backspace=indent,eol,start

augroup numbertog200
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave * set rnu
    autocmd BufLeave,FocusLost,InsertEnter * set nornu
augroup END

" braces
inoremap { {}<Left>
inoremap {<CR> {<CR>}<Esc>O
inoremap {{ {
inoremap {} {}

" open vimrc
nnoremap <F3> :tabnew <CR>:e $MYVIMRC<CR> 
inoremap <F3> :tabnew <CR>:e $MYVIMRC<CR>

" c compile
noremap <F8> <ESC> :w <CR> :!clang -std=c99 -g -O1 -Werror -fno-omit-frame-pointer -fno-optimize-sibling-calls -fsanitize=address,undefined,integer,nullability -fsanitize-address-use-after-scope -lm -Wall -o %< % && ./%< <CR>
inoremap <F8> <ESC> :w <CR> :!clang -std=c99 -g -O1 -Werror -fno-omit-frame-pointer -fno-optimize-sibling-calls -fsanitize=address,undefined,integer,nullability -fsanitize-address-use-after-scope -lm -Wall -o %< % && ./%< <CR>

" cpp compile
noremap <F9> <ESC> :w <CR> :!g++ -std=c++20 -Wall -Wextra -Wshadow -DONPC -O2 -o %< % && ./%< <CR>
inoremap <F9> <ESC> :w <CR> :!g++ -std=c++20 -Wall -Wextra -Wshadow -DONPC -O2 -o %< % && ./%< <CR>
noremap <F10> <ESC> :w <CR> :!g++ -std=c++20 -Wall -Wextra -Wshadow -DONPC -O2 -o %< % && ./%< < inp<CR>
inoremap <F10> <ESC> :w <CR> :!g++ -std=c++20 -Wall -Wextra -Wshadow -DONPC -O2 -o "%<" "%" && "./%<" < inp<CR>

autocmd filetype cpp nnoremap <C-C> :s/^\(\s*\)/\1\/\/<CR> :s/^\(\s*\)\/\/\/\//\1<CR> $

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

" Delete trailing white space on save
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

call plug#begin()

Plug 'SirVer/ultisnips'
Plug 'preservim/nerdtree'
Plug 'vimwiki/vimwiki'

call plug#end()

let wiki = {}
let wiki.path = '~/Documents/notes'
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips']
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="vertical"

nnoremap <F2> :NERDTreeToggle<CR>
inoremap <F2> :NERDTreeToggle<CR>
