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

Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate', ['branch'] = 'master'})

-- ==== BEGIN: LSP Support ====
-- LSP Support
Plug('neovim/nvim-lspconfig')
Plug('williamboman/mason.nvim')
Plug('williamboman/mason-lspconfig.nvim', {['branch'] = 'main'})
Plug('folke/lazydev.nvim')

-- Autocompletion Engine
Plug('saghen/blink.cmp', {['tag'] = 'v1.*'})

--  Snippets
Plug('L3MON4D3/LuaSnip')
Plug('rafamadriz/friendly-snippets')
-- ==== END: LSP Support ====

Plug('nvim-telescope/telescope.nvim', { ['branch'] = '0.1.x' })
Plug('hedyhli/outline.nvim')
Plug('nvim-tree/nvim-tree.lua')
Plug('stevearc/oil.nvim')

Plug('renerocksai/telekasten.nvim')

--Plug 'vim-pandoc/vim-pandoc'
--Plug 'vim-pandoc/vim-pandoc-syntax'

-- nvim 0.9.0 has editorconfig built-in, but w/ some issues
Plug('editorconfig/editorconfig-vim')

Plug('rust-lang/rust.vim')
Plug('nvim-lualine/lualine.nvim')
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
Plug('iamcco/markdown-preview.nvim', {
    ['do'] = function() vim.fn["mkdp#util#install"]() end,
    ['for'] = {'markdown', 'vim-plug'},
})
Plug('pest-parser/pest.vim')
Plug('mechatroner/rainbow_csv')

-- Make nvim picky
Plug('tris203/precognition.nvim')
Plug('m4xshen/hardtime.nvim')

-- AI!
if enable_ai then
    Plug('zbirenbaum/copilot.lua')
    Plug('CopilotC-Nvim/CopilotChat.nvim', { ['branch'] = 'main' })
end

Plug('folke/which-key.nvim')
Plug('rachartier/tiny-code-action.nvim')
Plug('windwp/nvim-ts-autotag')
if vim.fn.has("nvim-0.10.0") == 1 then
    Plug('folke/ts-comments.nvim')
end

vim.call('plug#end')
end -- plug_installed

-- Try to install plugins if this is the first time
if plug_just_installed then
    vim.cmd('PlugInstall')
end

-- alacritty can't handle cursor reshaping?
--vim.opt.guicursor = ""

-- mouse support
if vim.g.neovide then
    -- enable mouse support
    vim.opt.mouse = "nvi"
else
    -- disable mouse support
    vim.opt.mouse = ""
end

-- useful debug
function I(arg)
    print(vim.inspect(arg))
end

-- convert backslashes on windows to forward slashes
--vim.opt.shellslash = true -- breaks on nvim 0.10.0

-- Excluding version control directories
vim.opt.wildignore:append("*/.git/*,*/.hg/*,*/.svn/*")

vim.opt.hidden = true

function CustomTorte()
    vim.cmd('colorscheme torte')

    -- minor improvements
    local gutterfg = "#625e5a"
    local gutterbg = "#282727"
    local gutter_hl = { fg = gutterfg, bg = gutterbg}

    vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#f1f797", bg = "#404040" })
    vim.api.nvim_set_hl(0, "LineNr", gutter_hl)
    vim.api.nvim_set_hl(0, "SignColumn", gutter_hl)
end
vim.api.nvim_create_user_command('CustomTorte', CustomTorte, {})

if vim.env['TERMINAL_EMULATOR'] == 'JetBrains-JediTerm' then
    vim.cmd('colorscheme default')
else
    if pcall(function() vim.cmd('colorscheme kanagawa') end) then
        --vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#4b4b61", bg = "#4b4b61" })
    else
        -- fall back to built-in colorscheme
        CustomTorte()
    end
end

vim.opt.termguicolors = true

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

-- show trailing whitespace, ignoring special buffers
do
    local hl_group = "ExtraWhitespace"
    local ignore_filetypes = { "man", "mason", "help", "NvimTree", "TelescopePrompt", "blink-cmp-menu" }
    local ignore_buftypes = { "nofile", "prompt", "terminal", "popup", "acwrite" }

    local function ignore_trailing()
        return not vim.bo.modifiable
            or vim.list_contains(ignore_filetypes, vim.bo.filetype)
            or vim.list_contains(ignore_buftypes, vim.bo.buftype)
    end

    vim.api.nvim_set_hl(0, hl_group, { ctermbg = "red", bg = "red" })
    vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
        pattern = "*",
        callback = function()
            if ignore_trailing() then return end
            vim.fn.matchadd(hl_group, [[\s\+$]])
        end,
    })
    vim.api.nvim_create_autocmd({ "InsertEnter" }, {
        pattern = "*",
        callback = function()
            if ignore_trailing() then return end
            vim.fn.clearmatches()
        end,
    })
    vim.api.nvim_create_autocmd({ "InsertLeave" }, {
        pattern = "*",
        callback = function()
            if ignore_trailing() then return end
            vim.fn.matchadd(hl_group, [[\s\+$]])
        end,
    })
    vim.api.nvim_create_autocmd({ "BufWinLeave" }, {
        pattern = "*",
        callback = function()
            if ignore_trailing() then return end
            vim.fn.clearmatches()
        end,
    })
end

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

if vim.g.neovide then
    if vim.opt.shell:get() == "bash" then
        -- Workaround to fix env vars like PATH
        local handle = io.popen("bash -c 'if source ~/.bashrc >/dev/null 2>&1; then echo -n $PATH ; else exit 1 ; fi'")
        if handle then
            local result = handle:read("*a")
            handle:close()
            if result and #result > 0 then
                vim.env.PATH = result
            end
        end
    end

    -- clipboard copy/paste
    vim.keymap.set({ "n", "x" }, "<C-S-C>", '"+y', { desc = "Copy system clipboard" })
    vim.keymap.set({ "n", "x" }, "<C-S-V>", ':set paste<CR>"+p:set nopaste<CR>', { desc = "Paste system clipboard (paste mode)" })
    vim.cmd([[
        let g:neovide_input_use_logo = 1
        map <D-v> "+p<CR>
        map! <D-v> <C-R>+
        tmap <D-v> <C-R>+
        vmap <D-c> "+y<CR>
    ]])

    -- dynamic zoom/scale
    vim.g.neovide_scale_factor = 1.0
    local change_scale_factor = function(delta)
        vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
    end
    -- Support Ctrl prefix on all systems
    local prefixes = {"C"}
    if vim.loop.os_uname().sysname == 'Darwin' then
        -- only support Command prefix on Mac OS
        vim.list_extend(prefixes, {"D"})
    end
    for _, prefix in ipairs(prefixes) do
        vim.keymap.set("n", "<" .. prefix .. "-0>", function()
            vim.g.neovide_scale_factor = 1.0
        end, { desc = "Neovide: reset zoom" })
        vim.keymap.set("n", "<" .. prefix .. "-=>", function()
            change_scale_factor(1.25)
        end, { desc = "Neovide: zoom in" })
        vim.keymap.set("n", "<" .. prefix .. "-->", function()
            change_scale_factor(1/1.25)
        end, { desc = "Neovide: zoom out" })
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
        "markdown",
        "markdown_inline",
        "python",
        "regex",
        "rst",
        "rust",
        "toml",
        "typescript",
        "vim",
        "xml",
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


local supports_inlay_hints = vim.lsp.inlay_hint

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

-- use zls from path
if vim.fn.executable('zls') == 1 then
    vim.lsp.config('zls', {})
end

if vim.fn.executable('nu') == 1 then
    vim.lsp.config('nushell', {
        cmd = { "nu", "--lsp" },
        filetypes = { "nu" },
        root_dir = require("lspconfig.util").find_git_ancestor,
        single_file_support = true,
    })
end

-- Based on lsp-zero keybindings:
-- https://github.com/VonHeikemen/lsp-zero.nvim/tree/v3.x#keybindings
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local bufnr = event.buf
        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {buffer = bufnr, desc = desc})
        end
        map('n', 'K', vim.lsp.buf.hover, 'Hover info')
        map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
        map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
        map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
        map('n', 'go', vim.lsp.buf.type_definition, 'Go to type definition ')
        map('n', 'gs', vim.lsp.buf.signature_help, 'Help for signature')
        map('n', '<C-k>', vim.lsp.buf.signature_help, 'Help for signature')
        map('n', 'gl', vim.diagnostic.open_float, 'Show diag in float')
        map('n', '<F2>', vim.lsp.buf.rename, 'Rename symbol')
        map('n', '<leader>r', vim.lsp.buf.rename, 'Rename symbol')
        map('n', '<F3>', function() vim.lsp.buf.format({async = true}) end, 'Format file')
        map('x', '<F3>', function () vim.lsp.buf.format({async = true}) end, 'Format selection')
        -- instead of vim.lsp.buf.code_action
        map('n', '<F4>', require("tiny-code-action").code_action, 'Code action')
        map('n', 'g.', vim.lsp.buf.code_action, 'Code action')


        local id = vim.tbl_get(event, 'data', 'client_id')
        local client = {}
        if id then
            client = vim.lsp.get_client_by_id(id)
        end

        if supports_inlay_hints and client and client.server_capabilities.inlayHintProvider then
            local toggle_inlay_hint = function()
                local new_state = not vim.lsp.inlay_hint.is_enabled()
                print("inlay hint: " .. tostring(new_state))
                vim.lsp.inlay_hint.enable(new_state)
            end
            local opts = { buffer = bufnr, desc = 'Toggle inlay hints' }
            vim.keymap.set('n', '<leader>h', toggle_inlay_hint, opts)
            vim.keymap.set('n', '<leader>i', toggle_inlay_hint, opts)
        end

        --enable inlay hints by default
        if supports_inlay_hints then
            vim.lsp.inlay_hint.enable()
        end
    end,
})

require('lazydev').setup()

require('blink.cmp').setup({
    -- See :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
        preset = 'none',
        ['<C-e>'] = { 'show', 'hide', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
        ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-y>'] = { 'accept', 'fallback' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
    },
    appearance = {
        -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono'
    },
    completion = {
        keyword = { range = 'full' },
        documentation = { auto_show = true },
        list = {
            selection = {
                preselect = true,
                auto_insert = false,
            }
        },
        ghost_text = { enabled = true },
    },
    snippets = { preset = 'luasnip' },
    sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
            lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                -- make lazydev completions top priority (see `:h blink.cmp`)
                score_offset = 100,
            },
        },
    },
    signature = { enabled = true },
    fuzzy = { implementation = "prefer_rust_with_warning" },
})

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
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>tb', builtin.buffers, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Find help' })
vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = 'Find help' })
vim.keymap.set('n', '<leader>oo', builtin.lsp_document_symbols, { desc = 'Find document symbols' })
vim.keymap.set('n', '<leader>OO', builtin.lsp_workspace_symbols, { desc = 'Find workspace symbols' })
--vim.keymap.set('n', '<C-x>', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fx', builtin.lsp_references, { desc = 'Find references' })
vim.keymap.set('n', '<leader>gx', builtin.lsp_references, { desc = 'Find references' })

require("outline").setup()

-- gitsigns
local gitsigns = require('gitsigns')
gitsigns.setup()
vim.keymap.set('n', '[h', function() gitsigns.nav_hunk('prev') end, { desc = 'prev git hunk' })
vim.keymap.set('n', ']h', function() gitsigns.nav_hunk('next') end, { desc = 'next git hunk' })


--enable to make nvim picky
--require('precognition').setup({})
--require('hardtime').setup()

local hop = require('hop')
hop.setup({
    multi_windows = true,
})
vim.keymap.set('', '<leader>1', hop.hint_char1, {desc = 'hop: hint 1 char'})
vim.keymap.set('', '<leader>2', hop.hint_char2, {desc = 'hop: hint 2 char'})
vim.keymap.set('', '<leader>l', hop.hint_words, {desc = 'hop: hint words'})

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

require("oil").setup({
    default_file_explorer = false,
})

vim.cmd([[
augroup vimrc_help
  autocmd!
  autocmd BufEnter *.txt if &buftype == 'help' | wincmd L | endif
augroup END
]])

require('nvim-ts-autotag').setup()
require('ts-comments').setup()

require('lualine').setup({
    options = {
        icons_enabled = false,
        theme = 'powerline', -- matches lightline default
        component_separators = { left = '|', right = '|'},
        section_separators = { left = '', right = ''},
        always_divide_middle = true,
        always_show_tabline = false,
        globalstatus = false,
    },
    tabline = {
        lualine_a = {
            {
                'tabs',
                mode = 2,
                max_length = vim.o.columns,
            },
        },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
    -- sections for focused buffer
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {
            {
                'filename',
                path = 1, -- show the relative path and shorten $HOME to ~
            },
        },
        lualine_x = {'lsp_status', 'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
    -- sections for inactive buffers
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    extensions = {
        'man',
        'oil',
        'quickfix',
        'symbols-outline',
    }
})

require("tiny-code-action").setup({})
