-- Store in ~/.config/nvim/init.lua

-- Set the <leader>
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable netrw to let nvim-tree take over
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local enable_ai = false

--Plug commands like :PlugInstall, ...
--
-- NeoVim
-- Install vim-plug with:
-- curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
--     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
--
-- debug with :checkhealth

-- bootstrap plug
local bootstrap_plug = true
local plug_install_path = vim.fn.stdpath("data") .. "/site/autoload/plug.vim"
local plug_installed = false
local plug_just_installed = false
if (vim.uv or vim.loop).fs_stat(plug_install_path) then
    plug_installed = true
else
    if bootstrap_plug then
        local install_cmd = {
            "curl",
            "-fLo",
            plug_install_path,
            "--create-dirs",
            "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim",
        }
        print("installing plug package manager...")
        print("Install cmd: " .. table.concat(install_cmd, " "))
        local ok, err_msg = pcall(vim.fn.system, install_cmd)
        if not ok then
            print('Failed to install plug!')
            print(err_msg)
        else
            plug_installed = true
            plug_just_installed = true
        end
    end
end

local has_conform = false
if plug_installed then
vim.opt.rtp:prepend(plug_install_path)
local vim = vim
local Plug = vim.fn['plug#']
local platform_name =
    vim.loop.os_uname().machine
    .. "-"
    .. vim.loop.os_uname().sysname
local plug_path = vim.env.HOME .. '/.local/share/nvim/plugged/' .. platform_name
vim.call('plug#begin', plug_path)

if vim.fn.has('nvim-0.10') == 1 then
    Plug('stevearc/conform.nvim')
    has_conform = true
elseif vim.fn.has('nvim-0.9') == 1 then
    Plug('stevearc/conform.nvim', { ['branch'] = 'nvim-0.9' })
    has_conform = true
end

-- Indirect dependencies
Plug('nvim-lua/plenary.nvim') -- needed by telescope, hardtime, CopilotChat
Plug('MunifTanjim/nui.nvim') -- needed by hardtime

Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})

-- ==== BEGIN: LSP Support w/ lsp-zero ====
-- LSP Support
Plug('neovim/nvim-lspconfig')             -- Required
Plug('williamboman/mason.nvim')           -- Optional
Plug('williamboman/mason-lspconfig.nvim') -- Optional

-- Autocompletion Engine
Plug('hrsh7th/nvim-cmp')         -- Required
Plug('hrsh7th/cmp-nvim-lsp')     -- Required
Plug('hrsh7th/cmp-buffer')       -- Optional
Plug('hrsh7th/cmp-path')         -- Optional
Plug('saadparwaiz1/cmp_luasnip') -- Optional
Plug('hrsh7th/cmp-nvim-lua')     -- Optional

--  Snippets
Plug('L3MON4D3/LuaSnip')             -- Required
Plug('rafamadriz/friendly-snippets') -- Optional

Plug('VonHeikemen/lsp-zero.nvim', { ['branch'] = 'v3.x'})
-- ==== END: LSP Support w/ lsp-zero ====
Plug('nvim-telescope/telescope.nvim', { ['branch'] = '0.1.x' })
Plug('hedyhli/outline.nvim')
Plug('nvim-tree/nvim-tree.lua')


Plug('renerocksai/telekasten.nvim')

--Plug 'vim-pandoc/vim-pandoc'
--Plug 'vim-pandoc/vim-pandoc-syntax'

-- nvim 0.9.0 has editorconfig built-in, but w/ some issues
Plug('editorconfig/editorconfig-vim')

Plug('rust-lang/rust.vim')
Plug('itchyny/lightline.vim')
Plug('juneedahamed/vc.vim')
Plug('tpope/vim-fugitive')
Plug('tpope/vim-obsession')
Plug('dhruvasagar/vim-table-mode')
Plug('ziglang/zig.vim')
Plug('lewis6991/gitsigns.nvim')
Plug('mg979/vim-visual-multi')
Plug('smoka7/hop.nvim')
Plug('rebelot/kanagawa.nvim')
Plug('kaarmu/typst.vim')

-- Make nvim picky
Plug('tris203/precognition.nvim')
Plug('m4xshen/hardtime.nvim')

-- AI!
if enable_ai then
    Plug('zbirenbaum/copilot.lua')
    Plug('CopilotC-Nvim/CopilotChat.nvim', { ['branch'] = 'canary' })
end


vim.call('plug#end')
end -- plug_installed

-- Try to install plugins if this is the first time
if plug_just_installed then
    vim.cmd('PlugInstall')
end

-- alacritty can't handle cursor reshaping?
vim.opt.guicursor = ""

--[[ not needed for nvim?
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
--]]

-- Disable mouse support
vim.opt.mouse = ""

-- useful debug
function I(arg)
    print(vim.inspect(arg))
end

-- convert backslashes on windows to forward slashes
--vim.opt.shellslash = true -- breaks on nvim 0.10.0

-- Excluding version control directories
vim.opt.wildignore:append("*/.git/*,*/.hg/*,*/.svn/*")

vim.opt.hidden = true

if vim.env['TERMINAL_EMULATOR'] == 'JetBrains-JediTerm' then
    vim.cmd('colorscheme default')
else
    if pcall(function() vim.cmd('colorscheme kanagawa') end) then
        --vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#4b4b61", bg = "#4b4b61" })
    else
        -- fall back to built-in colorscheme
        vim.cmd('colorscheme torte')

        -- minor improvements
        local gutterfg = "#625e5a"
        local gutterbg = "#282727"
        local gutter_hl = { fg = gutterfg, bg = gutterbg}

        vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#f1f797", bg = "#404040" })
        vim.api.nvim_set_hl(0, "LineNr", gutter_hl)
        vim.api.nvim_set_hl(0, "SignColumn", gutter_hl)
    end
end

vim.opt.termguicolors = true

--[[
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
--]]

vim.cmd('autocmd BufNewFile,BufRead *.mir set syntax=rust')

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false

-- todo: make more fancy based on filetype
vim.opt.colorcolumn = {80}
vim.cmd('autocmd BufRead,BufNewFile *.rs set colorcolumn= colorcolumn=100')

-- min number of lines to show before/after cursor
vim.opt.scrolloff = 4

-- show trailing whitespace
vim.cmd([[
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
]])

vim.cmd('autocmd BufRead,BufNewFile *.ts,*.js,*.css set expandtab ts=2 sw=2 softtabstop=2')

--[[
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

unction StripSpaces() range
  let oldhlsearch=ShowSpaces(1)
  execute a:firstline.",".a:lastline."substitute ///gec"
  let &hlsearch=oldhlsearch
endfunction
--]]

vim.cmd([[
function! FindNonAscii()
   /[^\x00-\x7F]
endfunction
]]
)

for _, shell_cand in ipairs({ 'bash', 'zsh', 'sh' }) do
    if vim.fn.executable(shell_cand) == 1 then
        vim.opt.shell = shell_cand
        break
    end
end

-- Make "set list" more useful.
vim.opt.listchars:append('tab:^-')
vim.opt.listchars:append('trail:`')

if not plug_installed then
    -- print('plug not installed, skipping plugin config since bootstrap_plug is false')
    return
end

--------- Plugin config ---------

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
vim.keymap.set("n", "<leader>so", ":Outline<CR>", { desc = "Toggle Outline" })

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
        --"latex", --gives warning about treesitter CLI
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
    {name = 'buffer'},
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
local supports_inlay_hints = vim.lsp.inlay_hint
lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    local opts = {buffer = bufnr}
    local bind = vim.keymap.set

    -- https://github.com/neovim/nvim-lspconfig
    bind('n', '<leader>r', function() vim.lsp.buf.rename() end, opts)
    if supports_inlay_hints and client and client.server_capabilities.inlayHintProvider then
        local toggle_inlay_hint = function()
            local new_state = not vim.lsp.inlay_hint.is_enabled()
            print("inlay hint: " .. tostring(new_state))
            vim.lsp.inlay_hint.enable(new_state)
        end
        bind('n', '<leader>h', toggle_inlay_hint, opts)
        bind('n', '<leader>i', toggle_inlay_hint, opts)
    end

    lsp_zero.default_keymaps({buffer = bufnr})

    if supports_inlay_hints then
        vim.lsp.inlay_hint.enable() --enable inlay hints by default
    end
end)

-- Workaround for slow LSP (such as rust-analyzer) that does not provide inlay
-- hints by the time `on_attach` is called.
-- Based on:
-- https://github.com/mrcjkb/rustaceanvim/blob/a73e8618d8518b2a7434e1c21e4da4e66f21f738/lua/rustaceanvim/server_status.lua#L14
if supports_inlay_hints then
    local M = {}
    vim.lsp.handlers['experimental/serverStatus'] = function(_, result, ctx, _)
        --print('Received serverStatus notification:', vim.inspect(result))
        if result.quiescent and not M.ran_once then
            for _, bufnr in ipairs(vim.lsp.get_buffers_by_client_id(ctx.client_id)) do
                --print('serverStatus: flushing inlay')
                vim.lsp.inlay_hint.enable(false, { bufnr = bufnr });
                vim.lsp.inlay_hint.enable(true, { bufnr = bufnr });
            end
            M.ran_once = true
        end
    end
end

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

local table_contains = function(tbl, item)
    for _, value in pairs(tbl) do
        if value == item then
            return true
        end
    end
    return false
end

-- Mason fails to install binaries on less common platforms, so only
-- auto-install binaries when it will likely work
local is_bin_install_ok = false
if table_contains({'Linux', 'Darwin'}, vim.loop.os_uname().sysname) then
    is_bin_install_ok = true
end

local ensure_installed = {}
if is_bin_install_ok then
    ensure_installed = {
        'lua_ls',
        'rust_analyzer',
    }
end
require('mason-lspconfig').setup({
    ensure_installed = ensure_installed,
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
vim.keymap.set('n', '<leader>tb', builtin.buffers, {})
--vim.keymap.set('n', '<C-x>', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fx', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>gx', builtin.lsp_references, {})

require("outline").setup()

-- gitsigns
local gitsigns = require('gitsigns')
gitsigns.setup()
vim.keymap.set('n', '[h', function() gitsigns.nav_hunk('prev') end)
vim.keymap.set('n', ']h', function() gitsigns.nav_hunk('next') end)


--enable to make nvim picky
--require('precognition').setup({})
--require('hardtime').setup()

local hop = require('hop')
hop.setup({
    multi_windows = true,
})
vim.keymap.set('', '<leader>1', function ()
    hop.hint_char1()
end)
vim.keymap.set('', '<leader>2', function ()
    hop.hint_char2()
end)
vim.keymap.set('', '<leader>l', function ()
    hop.hint_words()
end)

-- empty setup using defaults
require("nvim-tree").setup()

require('telekasten').setup({
    -- debug = true,
    -- Put the name of your notes directory here
    home = vim.fn.expand("~/zettelkasten"),
    take_over_my_home = false,
    auto_set_filetype = false,
})

-- AI!
if enable_ai then
    -- https://github.com/zbirenbaum/copilot.lua
    require('copilot').setup({
        panel = {
            enabled = true,
            auto_refresh = false,
            keymap = {
                jump_prev = "[[",
                jump_next = "]]",
                accept = "<CR>",
                refresh = "gr",
                open = "<M-CR>"
            },
            layout = {
                position = "bottom", -- | top | left | right
                ratio = 0.4
            },
        },
        suggestion = {
            enabled = true,
            auto_trigger = true,
            hide_during_completion = true,
            debounce = 75,
            keymap = {
                --accept = "<M-l>", -- conflicts with tmux
                accept = "<C-Space>",
                accept_word = false,
                accept_line = false,
                next = "<M-]>",
                prev = "<M-[>",
                dismiss = "<C-]>",
            },
        },
    })
    -- https://github.com/CopilotC-Nvim/CopilotChat.nvim
    require("CopilotChat").setup {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    }
end

if has_conform then
    require("conform").setup({
        formatters_by_ft = {
            lua = { "stylua" },
            -- Conform will run multiple formatters sequentially
            python = { "isort", "black" },
            -- You can customize some of the format options for the filetype (:help conform.format)
            rust = { "rustfmt", lsp_format = "fallback" },
            -- Conform will run the first available formatter
            javascript = { "prettierd", "prettier", stop_after_first = true },
        },
    })
    local format_buffer = function(args)
        local range = nil
        if args.count ~= -1 then
            local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
            range = {
                start = { args.line1, 0 },
                ["end"] = { args.line2, end_line:len() },
            }
        end
        require("conform").format({ async = true, lsp_format = "fallback", range = range })
    end
    vim.api.nvim_create_user_command("Format", format_buffer, { range = true })
end
