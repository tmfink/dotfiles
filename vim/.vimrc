set nocompatible
filetype on

" Set the <leader>
let mapleader = " "

"Plug commands like :PlugInstall, ...

if has('nvim')
    " NeoVim
    " Install vim-plug with:
    " curl -fLo ~/.local/share"/nvim/site/autoload/plug.vim --create-dirs \
    "     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    "
    " debug with :checkhealth
    lua vim.g["platform_name"] =
        \ vim.loop.os_uname().machine .. "-" .. vim.loop.os_uname().sysname

    call plug#begin('~/.local/share/nvim/plugged/' . platform_name)

    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

    " ==== BEGIN: LSP Support w/ lsp-zero ====
    " LSP Support
    Plug 'neovim/nvim-lspconfig'             " Required
    Plug 'williamboman/mason.nvim'           " Optional
    Plug 'williamboman/mason-lspconfig.nvim' " Optional

    " Autocompletion Engine
    Plug 'hrsh7th/nvim-cmp'         " Required
    Plug 'hrsh7th/cmp-nvim-lsp'     " Required
    Plug 'hrsh7th/cmp-buffer'       " Optional
    Plug 'hrsh7th/cmp-path'         " Optional
    Plug 'saadparwaiz1/cmp_luasnip' " Optional
    Plug 'hrsh7th/cmp-nvim-lua'     " Optional

    "  Snippets
    Plug 'L3MON4D3/LuaSnip'             " Required
    Plug 'rafamadriz/friendly-snippets' " Optional

    Plug 'VonHeikemen/lsp-zero.nvim', {'branch': 'v3.x'}
    " ==== END: LSP Support w/ lsp-zero ====

    Plug 'nvim-lua/plenary.nvim' " needed by telescope
    Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
    Plug 'simrat39/symbols-outline.nvim'
else
    " Vim
    " Install vim-plug with:
    " curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    "     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    call plug#begin('~/.vim/plugged')
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif

"Common Vim/Neovim installs
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'rust-lang/rust.vim'
Plug 'itchyny/lightline.vim'
Plug 'juneedahamed/vc.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'editorconfig/editorconfig-vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'ziglang/zig.vim'

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
"autocmd BufRead,BufNewFile *.rs set colorcolumn= colorcolumn=100

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


" ====== nvim plugin config =======
if has('nvim')
lua << EOF
-- remaps

-- drag visual selected text up/down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- up/down jumps keep centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- paste over selection without touching registers
vim.keymap.set("x", "<leader>p", [["_dP]])

-- replace current selection
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- toggle symbol outline
vim.keymap.set("n", "<leader>so", ":SymbolsOutline<CR>")

require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all"
    ensure_installed = {
        "bash",
        "c",
        "cpp",
        "diff",
        "dockerfile",
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

    --[[
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn", -- set to `false` to disable one of the mappings
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    --]]
}

local cmp = require('cmp')

cmp.setup({
  preselect = 'item',
  completion = {
    completeopt = 'menu,menuone,noinsert'
  },
  sources = {
    {name = 'nvim_lsp'},
  },
  mapping = {
    ['<C-y>'] = cmp.mapping.confirm({select = false}),
    ['<CR>'] = cmp.mapping.confirm({select = false}),
    -- toggle completion window
    ['<C-e>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.abort()
      else
        cmp.complete()
      end
    end),
    ['<Up>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
    ['<Down>'] = cmp.mapping.select_next_item({behavior = 'select'}),
    ['<C-p>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item({behavior = 'insert'})
      else
        cmp.complete()
      end
    end),
    ['<C-n>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item({behavior = 'insert'})
      else
        cmp.complete()
      end
    end),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),

  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
})

--[[
lsp-zero keybindings:
https://github.com/VonHeikemen/lsp-zero.nvim/tree/v3.x#keybindings

K: Displays hover information about the symbol under the cursor window.
gd: Jumps to the definition of the symbol under the cursor.
gD: Jumps to the declaration of the symbol under the cursor.
gi: Lists all the implementations for the symbol under the cursor in the
    quickfix window.
go: Jumps to the definition of the type of the symbol under the cursor.
gr: Lists all the references to the symbol under the cursor in the quickfix
    window.
<Ctrl-k>: Displays signature information about the symbol under the cursor in
    a floating window.
<F2>: Renames all references to the symbol under the cursor.
<F4>: Selects a code action available at the current cursor position.
gl: Show diagnostics in a floating window.
[d: Move to the previous diagnostic in the current buffer.
]d: Move to the next diagnostic.

--]]
local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    local opts = {buffer = bufnr}
    local bind = vim.keymap.set

    -- https://github.com/neovim/nvim-lspconfig
    bind('n', '<leader>r', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)

    lsp_zero.default_keymaps({buffer = bufnr})
end)

local lspconfig = require('lspconfig')

-- (Optional) Configure lua language server for neovim
local lua_opts = lsp_zero.nvim_lua_ls()
lspconfig.lua_ls.setup(lua_opts)

-- use zls from path
if vim.fn.executable('zls') == 1 then
    lspconfig.zls.setup{}
end

lsp_zero.setup()

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {'rust_analyzer'},
    handlers = {
        lsp_zero.default_setup,
    },
})

vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = false,
    float = true,
})

-- telescope
-- https://github.com/nvim-telescope/telescope.nvim/tree/master#default-mappings
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>oo', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>OO', builtin.lsp_workspace_symbols, {})

require("symbols-outline").setup()

EOF
endif "nvim
