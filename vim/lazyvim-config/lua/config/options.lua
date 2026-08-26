-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

I = vim.inspect

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

vim.cmd([[
function! FindNonAscii()
   /[^\x00-\x7F]
endfunction
]])

for _, shell_cand in ipairs({ "bash", "zsh", "sh" }) do
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
  vim.keymap.set(
    { "n", "x" },
    "<C-S-V>",
    ':set paste<CR>"+p:set nopaste<CR>',
    { desc = "Paste system clipboard (normal/paste mode)" }
  )
  vim.keymap.set({ "i" }, "<C-S-V>", '<ESC>l"+Pi', { noremap = true, desc = "Paste system clipboard (insert mode)" })
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
  local prefixes = { "C" }
  if vim.loop.os_uname().sysname == "Darwin" then
    -- only support Command prefix on Mac OS
    vim.list_extend(prefixes, { "D" })
  end
  for _, prefix in ipairs(prefixes) do
    vim.keymap.set("n", "<" .. prefix .. "-0>", function()
      vim.g.neovide_scale_factor = 1.0
    end, { desc = "Neovide: reset zoom" })
    vim.keymap.set("n", "<" .. prefix .. "-=>", function()
      change_scale_factor(1.25)
    end, { desc = "Neovide: zoom in" })
    vim.keymap.set("n", "<" .. prefix .. "-->", function()
      change_scale_factor(1 / 1.25)
    end, { desc = "Neovide: zoom out" })
  end
end

-- Make "set list" more useful.
vim.opt.listchars:append("tab:^-")
vim.opt.listchars:append("trail:`")

local supports_inlay_hints = vim.lsp.inlay_hint

-- Workaround for slow LSP (such as rust-analyzer) that does not provide inlay
-- hints by the time `on_attach` is called.
-- Based on:
-- https://github.com/mrcjkb/rustaceanvim/blob/a73e8618d8518b2a7434e1c21e4da4e66f21f738/lua/rustaceanvim/server_status.lua#L14
if supports_inlay_hints then
  local M = {}
  vim.lsp.handlers["experimental/serverStatus"] = function(_, result, ctx, _)
    --print('Received serverStatus notification:', vim.inspect(result))
    if result.quiescent and not M.ran_once then
      for _, bufnr in ipairs(vim.lsp.get_buffers_by_client_id(ctx.client_id)) do
        --print('serverStatus: flushing inlay')
        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
      M.ran_once = true
    end
  end
end

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function(args)
    -- workaround for issue when opening some files with ft set but not syntax
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    for _, ft in ipairs({ "python", "rust" }) do
      if vim.bo[args.buf].filetype == ft and vim.bo[args.buf].syntax == "" then
        vim.bo[args.buf].syntax = ft
      end
    end
  end,
})
