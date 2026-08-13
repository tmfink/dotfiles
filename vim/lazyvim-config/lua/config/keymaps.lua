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
vim.keymap.set("n", "<leader>so", ":Outline<CR>", { desc = "Toggle Outline" })

-- toggle inlay hints
if vim.lsp.inlay_hint then
  Snacks.toggle.inlay_hints():map("<leader>h")
  Snacks.toggle.inlay_hints():map("<leader>i")
end

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>tb", builtin.buffers, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>oo", builtin.lsp_document_symbols, { desc = "Find document symbols" })
vim.keymap.set("n", "<leader>OO", builtin.lsp_workspace_symbols, { desc = "Find workspace symbols" })
vim.keymap.set("n", "<leader>fx", builtin.lsp_references, { desc = "Find references" })
vim.keymap.set("n", "<leader>gx", builtin.lsp_references, { desc = "Find references" })

-- Custom command to create today's note from the most recent previous note
vim.api.nvim_create_user_command("TelekastenCreateToday", function()
    local tk = require("telekasten")

    -- Default configuration values
    local switch_message = function(msg)
        vim.defer_fn(function()
            vim.notify(msg, vim.log.levels.INFO)
        end, 500)
        tk.goto_today({ journal_auto_open = true })
    end

    -- Try to detect configuration from Telekasten
    local ext = tk.Cfg.extension
    local dailies_path = tk.Cfg.dailies
    local today = os.date("%Y-%m-%d")
    local today_file = dailies_path .. "/" .. today .. ext

    -- If today's note already exists, just go there
    if vim.fn.filereadable(today_file) == 1 then
        switch_message("Today's note already exists, switching to it")
        return
    end

    -- Find the most recent previous daily note
    local files = vim.fn.glob(dailies_path .. "/*" .. ext, true, true)
    table.sort(files)

    local prev_file = nil
    for i = #files, 1, -1 do
        local f = files[i]
        local name = vim.fn.fnamemodify(f, ":t:r") -- filename without extension
        if name < today then
            prev_file = f
            break
        end
    end

    -- Copy content if a previous file was found
    if prev_file then
        local lines = vim.fn.readfile(prev_file)
        vim.fn.writefile(lines, today_file)
        switch_message("Created today's note from " .. vim.fn.fnamemodify(prev_file, ":t:r"))
    else
        switch_message("No previous daily note found. Creating fresh note.")
    end
end, {})
