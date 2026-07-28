-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local hop = require("hop")
vim.keymap.set("", "<leader>1", hop.hint_char1, { desc = "hop: hint 1 char" })
vim.keymap.set("", "<leader>2", hop.hint_char2, { desc = "hop: hint 2 char" })
vim.keymap.set("", "<leader>l", hop.hint_words, { desc = "hop: hint words" })

-- up/down jumps keep centered
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- toggle symbol outline
-- vim.keymap.set("n", "<leader>so", ":Outline<CR>", { desc = "Toggle Outline" })
