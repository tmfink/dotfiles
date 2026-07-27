-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.clipboard = ""
vim.opt.showcmd = false

vim.g.autoformat = false
vim.g.snacks_animate = false

-- mouse support
if vim.g.neovide then
    -- enable mouse support
    vim.opt.mouse = "nvi"
else
    -- disable mouse support
    vim.opt.mouse = ""
end
