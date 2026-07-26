-- Add plugins:
--[[
Plug("creativenull/efmls-configs-nvim", { ["tag"] = "v1.*" }) -- pre-configured linters and formatters for efm-langserver
Plug('stevearc/oil.nvim')
Plug('juneedahamed/vc.vim')
Plug('renerocksai/telekasten.nvim')
Plug('nvim-lualine/lualine.nvim')
Plug('dhruvasagar/vim-table-mode')
Plug('smoka7/hop.nvim')
Plug('kaarmu/typst.vim')
Plug('kaarmu/typst.vim')
Plug('iamcco/markdown-preview.nvim', {
    ['do'] = function() vim.fn["mkdp#util#install"]() end,
    ['for'] = {'markdown', 'vim-plug'},
})
Plug('mechatroner/rainbow_csv')
Plug('tris203/precognition.nvim')
Plug('m4xshen/hardtime.nvim')
--]]

return {
  -- add colorschemes
  { "ellisonleao/gruvbox.nvim" },
  { "rebelot/kanagawa.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },

  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    opts = {},
  },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "rust",
        "tsx",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },

  -- or you can return new options to override all the defaults
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        --[[add your custom lualine config here]]
      }
    end,
  },

  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "basedpyright",
        "clangd",
        "efm",
        "ruff",
        "rust-analyzer",
        "shellcheck",
        "shfmt",
        "stylua",
        "tinymist",
      },
    },
  },

  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        -- classic cmdline view instead of a popup
        view = "cmdline",
      },
    },
  },
}
