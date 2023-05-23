local plugins = {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,

    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require "custom.configs.null-ls"
      end,
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "rust-analyzer",
        "typescript-language-server",
        "tailwindcss-language-server",
        "prettierd",
        "eslint_d",
        "stylua",
        "clangd",
        "clang-format"
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        -- defaults
        "vim",
        "lua",

        -- web dev
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "json",

        -- rust
        "rust",

        -- low level
        "c",
      },
    },
  },
  {
    "ThePrimeagen/harpoon",
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    config = function()
      local rt = require "rust-tools"
      rt.setup()
    end,
  },
  {
    "mg979/vim-visual-multi",
    lazy = false,
  },
}

return plugins
