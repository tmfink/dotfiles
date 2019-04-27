"Vundle
set nocompatible              " be iMproved, required
filetype off                  " required


if has('nvim')
    " NeoVim

    " Hack to set TERM environment variable when in tmux
    let $TERM='xterm256-color'

	call plug#begin('~/.local/share/nvim/plugged')
	"call plug#begin()
	Plug 'tpope/vim-sensible'

    Plug 'scrooloose/syntastic'
    Plug 'vim-pandoc/vim-pandoc'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'kien/ctrlp.vim'
    Plug 'scrooloose/nerdtree'
    Plug 'jistr/vim-nerdtree-tabs'
    Plug 'roxma/nvim-completion-manager'

    " rust
    Plug 'wting/rust.vim'
    Plug 'racer-rust/vim-racer'
    Plug 'roxma/nvim-cm-racer'


    set shortmess+=c
    inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
    inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
    inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
	" Language Server
	Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }

	" (Optional) Multi-entry selection UI.
	Plug 'junegunn/fzf'
	" (Optional) Multi-entry selection UI.
	Plug 'Shougo/denite.nvim'

	" (Optional) Completion integration with deoplete.
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	" (Optional) Completion integration with nvim-completion-manager.
	Plug 'roxma/nvim-completion-manager'

	" (Optional) Showing function signature and inline doc.
	Plug 'Shougo/echodoc.vim'
	call plug#end()

	" Required for operations modifying multiple buffers like rename.
	set hidden

	let g:LanguageClient_serverCommands = {
		\ 'rust': ['rustup', 'run', 'nightly', 'rls'],
		\ 'javascript': ['/opt/javascript-typescript-langserver/lib/language-server-stdio.js'],
		\ }

	" Automatically start language servers.
	let g:LanguageClient_autoStart = 1

	nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
	nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
	nnoremap <silent> <F2> :call LanguageClient_textDocument_rename()<CR>
else
    " Vim
    " set the runtime path to include Vundle and initialize

    "set rtp+=~/.vim/bundle/Vundle.vim
    "call vundle#begin()
    call plug#begin('~/.vim/plugged')

    " alternatively, pass a path where Vundle should install plugins
    "call vundle#begin('~/some/path/here')

    " let Vundle manage Vundle, required
    Plug 'gmarik/Vundle.vim'

    " The following are examples of different formats supported.
    " Keep Plugin commands between vundle#begin/end.
    Plug 'scrooloose/syntastic'
    Plug 'vim-pandoc/vim-pandoc'
    Plug 'vim-pandoc/vim-pandoc-syntax'
    Plug 'kien/ctrlp.vim'
    Plug 'wting/rust.vim'
    Plug 'racer-rust/vim-racer'
    "Plug 'Valloric/YouCompleteMe'
    "Plug 'scrooloose/nerdtree'
    "Plug 'jistr/vim-nerdtree-tabs'

    " All of your Plugins must be added before the following line
    "call vundle#end()            " required
    call plug#end()

    "
    " Brief help
    " :PluginList       - lists configured plugins
    " :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
    " :PluginSearch foo - searches for foo; append `!` to refresh local cache
    " :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
    "
    " see :h vundle for more details or wiki for FAQ
    " Put your non-Plugin stuff after this line

endif

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on

" Disable mouse support
set mouse=

"ctrlp.vim
set runtimepath^=~/.vim/bundle/ctrlp.vim
" Excluding version control directories
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*        " Linux/MacOSX
set wildignore+=*\\.git\\*,*\\.hg\\*,*\\.svn\\*  " Windows ('noshellslash')

"vim-racer
set hidden
let g:racer_cmd = "$HOME/.cargo/bin/racer"
let $RUST_SRC_PATH="$HOME/workspace/rust/src/"


"syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_mode_map = {
    \ "mode": "passive",
    \ "active_filetypes": [],
    \ "passive_filetypes": [] }

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"

if $TERMINAL_EMULATOR == "JetBrains-JediTerm"
    colorscheme default
else
    colorscheme torte
endif

set autoindent
"set smartindent
set hidden
set wildmenu
set hlsearch

:syntax enable
set tabstop=4  " tab is 4 spaces wide
set shiftwidth=4 " indent with 4 spaces
set softtabstop=4
set expandtab  " expand tabs to spaces
autocmd FileType make set noexpandtab
autocmd BufNewFile,BufRead *.mir set syntax=rust

set backspace=2 " make backspace work like most other apps
set number " turn line numbers on
set nocompatible " turn off emulation of vi bugs
set nowrap

set ruler "show col/row

"Override vim settings if necessary with file in current directory
if filereadable(".project.vimrc")
    source .project.vimrc
endif

function ShowSpaces(...)
  let @/='\v(\s+$)|( +\ze\t)'
  let oldhlsearch=&hlsearch
  if !a:0
    let &hlsearch=!&hlsearch
  else
    let &hlsearch=a:1
  end
  return oldhlsearch
endfunction

function StripSpaces() range
  let oldhlsearch=ShowSpaces(1)
  execute a:firstline.",".a:lastline."substitute ///gec"
  let &hlsearch=oldhlsearch
endfunction

"command -bar -nargs=? ShowSpaces call ShowSpaces(<args>)
"command -bar -nargs=0 -range=% TrimSpaces <line1>,<line2>call TrimSpaces()

let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

set shell=/bin/bash

" Make "show list" more useful.
set listchars+=tab:^-
set listchars+=trail:`

