set nocompatible
filetype on

"Plug commands like :PlugInstall, ...

" To configure Neovim:
" $ cat ~/.config/nvim/init.vim
" set runtimepath^=~/.vim runtimepath+=~/.vim/after
" let &packpath=&runtimepath
" source ~/.vimrc

if has('nvim')
    " NeoVim
    " Install vim-plug with:
    " curl -fLo ~/.local/share"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    "
    " debug with :checkhealth
    call plug#begin('~/.local/share/nvim/plugged')

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
else
    " Vim
    " Install vim-plug with:
    " curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    call plug#begin('~/.vim/plugged')
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif

"Common Vim/Neovim installs
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'rust-lang/rust.vim'
Plug 'itchyny/lightline.vim'
Plug 'editorconfig/editorconfig-vim'


Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

if !has('gui_running')
    set t_Co=256
endif

if has('nvim')
    "alacritty can't handle cursor reshaping?
    set guicursor=
else
    " Vim
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
set nocompatible " turn off emulation of vi bugs
set nowrap

set ruler "show col/row

"show trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()


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
    let output=trim(system("which " . shell_cand))
    if len(output) > 0 && filereadable(output)
        let &shell=output
        break
    endif
endfor

" Make "show list" more useful.
set listchars+=tab:^-
set listchars+=trail:`


"FZF
nnoremap <silent> <C-p> :Files<CR>

" ====== nvim plugin config =======
if has('nvim')
lua << EOF
    require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = {
      "bash",
      "c",
      "cpp",
      "diff",
      "dockerfile",
      "help",
      "html",
      "javascript",
      "latex",
      "lua",
      "make",
      "python",
      "rust",
      "rst",
      "toml",
      "typescript",
      "vim",
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = false,

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF
endif "nvim
