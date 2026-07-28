-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local function set_space_indent(width)
  vim.bo.expandtab = true
  vim.bo.ts = width
  vim.bo.sw = width
  vim.bo.softtabstop = width
end

-- show trailing whitespace, ignoring special buffers
do
  local hl_group = "ExtraWhitespace"

  local ignore_filetypes = {
    "man",
    "mason",
    "help",
    "NvimTree",
    "TelescopePrompt",
    "blink-cmp-menu",
  }

  local ignore_buftypes = {
    "nofile",
    "prompt",
    "terminal",
    "popup",
    "acwrite",
  }

  local function ignore_trailing()
    return not vim.bo.modifiable
      or vim.list_contains(ignore_filetypes, vim.bo.filetype)
      or vim.list_contains(ignore_buftypes, vim.bo.buftype)
      or vim.startswith(vim.bo.filetype, "snacks")
      or vim.startswith(vim.bo.filetype, "noice")
  end

  local function clear_match()
    if vim.w.trailing_ws_match then
      pcall(vim.fn.matchdelete, vim.w.trailing_ws_match)
      vim.w.trailing_ws_match = nil
    end
  end

  local function show_match()
    clear_match()

    if ignore_trailing() then
      return
    end

    vim.w.trailing_ws_match = vim.fn.matchadd(hl_group, [[\s\+$]])
  end

  vim.api.nvim_set_hl(0, hl_group, {
    bg = "red",
    ctermbg = "red",
  })

  local group = vim.api.nvim_create_augroup("TrailingWhitespace", { clear = true })

  vim.api.nvim_create_autocmd({
    "BufEnter",
    "BufWinEnter",
    "WinEnter",
    "InsertLeave",
  }, {
    group = group,
    callback = show_match,
  })

  vim.api.nvim_create_autocmd({
    "InsertEnter",
    "BufWinLeave",
    "WinLeave",
  }, {
    group = group,
    callback = clear_match,
  })
end

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.mir",
  callback = function()
    vim.bo.syntax = "rust"
    set_space_indent(4)
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.rs", "*.py", "Cargo.toml*", "Cargo.lock" },
  callback = function()
    set_space_indent(4)
  end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "*.ts", "*.js", "*.css", "*.json" },
  callback = function()
    set_space_indent(2)
  end,
})
