set nocompatible
filetype on

" Set the <leader>
let mapleader = " "

"Plug commands like :PlugInstall, ...
"
" Install vim-plug with:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
call plug#begin('~/.vim/plugged')
Plug 'roxma/nvim-yarp'
Plug 'roxma/vim-hug-neovim-rpc'

"Common Vim/Neovim installs
if v:version >= 740
    Plug 'vim-pandoc/vim-pandoc'
    Plug 'vim-pandoc/vim-pandoc-syntax'
endif

Plug 'editorconfig/editorconfig-vim'
Plug 'rust-lang/rust.vim'
Plug 'itchyny/lightline.vim'
Plug 'juneedahamed/vc.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'dhruvasagar/vim-table-mode'
Plug 'ziglang/zig.vim'

call plug#end()

if !has('gui_running')
    set t_Co=256
endif

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" Disable mouse support
set mouse=

" Excluding version control directories
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*        " Linux/MacOSX
set wildignore+=*\\.git\\*,*\\.hg\\*,*\\.svn\\*  " Windows ('noshellslash')

set hidden

"lightline: fix display
set laststatus=2
set noshowmode "do not need Vim's default bar

if $TERMINAL_EMULATOR == "JetBrains-JediTerm"
    colorscheme default
else
    colorscheme torte
endif
if has("termguicolors")
    set termguicolors
endif

let g:lightline = {
    \ 'component': {
        \ 'charvaluehex': '0x%B'
    \ },
\ }
let g:lightline.component_type = {
    \  'linter_checking': 'left',
    \  'linter_warnings': 'warning',
    \  'linter_errors': 'error',
    \  'linter_ok': 'left',
    \ }
let g:lightline.active = {
    \ 'right': [
        \ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ],
        \ [ 'lineinfo' ],
        \ [ 'percent' ],
    \ ]
\ }


set autoindent
"set smartindent
set wildmenu
set hlsearch

syntax on
set tabstop=4  " tab is 4 spaces wide
set shiftwidth=4 " indent with 4 spaces
set softtabstop=4
set expandtab  " expand tabs to spaces
autocmd FileType make set noexpandtab
autocmd BufNewFile,BufRead *.mir set syntax=rust

set backspace=2 " make backspace work like most other apps
set number " turn line numbers on
set relativenumber
set nocompatible " turn off emulation of vi bugs
set nowrap
set colorcolumn=80

"min number of lines to show before/after cursor
set scrolloff=4

set ruler "show col/row

"show trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

autocmd BufRead,BufNewFile *.ts,*.js,*.css set expandtab ts=2 sw=2 softtabstop=2
autocmd BufRead,BufNewFile *.rs set colorcolumn= colorcolumn=100

"function ShowSpaces(...)
"  let @/='\v(\s+$)|( +\ze\t)'
"  let oldhlsearch=&hlsearch
"  if !a:0
"    let &hlsearch=!&hlsearch
"  else
"    let &hlsearch=a:1
"  end
"  return oldhlsearch
"endfunction

"function StripSpaces() range
"  let oldhlsearch=ShowSpaces(1)
"  execute a:firstline.",".a:lastline."substitute ///gec"
"  let &hlsearch=oldhlsearch
"endfunction

function! FindNonAscii()
   /[^\x00-\x7F]
endfunction

for shell_cand in ["bash", "zsh", "sh"]
    if executable(shell_cand)
        let &shell=shell_cand
        break
    endif
endfor

" Make "show list" more useful.
set listchars+=tab:^-
set listchars+=trail:`
