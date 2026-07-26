-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

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
