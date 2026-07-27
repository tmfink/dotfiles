-- Add plugins:
--[[
-- Something for Subversion?
Plug('juneedahamed/vc.vim')
--]]

-- returns index of matching item or nil if none found
local function search_list(list, condition)
  for i, value in ipairs(list) do
    if condition(value) then
      return i -- Return the index of the found item
    end
  end
  return nil
end

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
    opts = function(_, opts)
      opts.options.theme = "powerline" -- matches lightline default
      local ft_idx = search_list(opts.sections.lualine_c, function(x)
        return x ~= nil and x[1] == "filetype"
      end)
      if ft_idx == nil then
        vim.notify("could not find filetype in lualine_c!")
      else
        table.remove(opts.sections.lualine_c, ft_idx)
      end

      opts.sections.lualine_x = {
        "lsp_status",
        { "encoding", icons_enabled = false },
        { "fileformat", icons_enabled = false },
        "filetype",
      }
      opts.sections.lualine_y = {
        "progress",
      }
      opts.sections.lualine_z = {
        "location",
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

  -- disable illumiate?
  {
    "RRethy/vim-illuminate",
  },

  {
    "creativenull/efmls-configs-nvim",
    version = "v1.x.x", -- version is optional, but recommended
    config = function()
      local languages = require("efmls-configs.defaults").languages() -- start w/ defaults

      local shellcheck = require("efmls-configs.linters.shellcheck")
      local ruff = require("efmls-configs.linters.ruff")
      local shfmt = require("efmls-configs.formatters.shfmt")

      local sh_like = { shellcheck, shfmt }
      languages.sh = sh_like
      languages.bash = sh_like

      local efmls_config = {
        filetypes = vim.tbl_keys(languages),
        settings = {
          rootMarkers = { ".git/" },
          languages = languages,
        },
        init_options = {
          documentFormatting = true,
          documentRangeFormatting = true,
        },
      }

      -- If using nvim >= 0.11 then use the following
      vim.lsp.config(
        "efm",
        vim.tbl_extend("force", efmls_config, {
          cmd = { "efm-langserver" },

          -- Pass your custom lsp config below like on_attach and capabilities
          --
          -- on_attach = on_attach,
          -- capabilities = capabilities,
        })
      )
    end,
  },

  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = false,
    },
    -- Optional dependencies
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
    lazy = false,
  },

  {
    "renerocksai/telekasten.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    opts = {
      -- debug = true,
      -- Put the name of your notes directory here
      home = vim.fn.expand("~/zettelkasten"),
      take_over_my_home = false,
      -- auto_set_filetype = false,
    },
  },

  {
    "smoka7/hop.nvim",
    version = "*",
    opts = {
      keys = "etovxqpdygfblzhckisuran",
      multi_windows = true,
    },
  },

  { "mechatroner/rainbow_csv" },

  {
    "tris203/precognition.nvim",
    opts = {},
    enabled = false,
  },

  {
    "m4xshen/hardtime.nvim",
    lazy = false,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    enabled = false,
  },
}
