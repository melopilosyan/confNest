return {
  {
    "melopilosyan/rspec-integrated.nvim",
    lazy = true,
    dev = false,
  },

  {
    "tpope/vim-rake",
    event = "LazyFile",
    dependencies = { "tpope/vim-projectionist" },
    ft = { "ruby" }
  },

  {
    "tpope/vim-bundler",
    event = "LazyFile",
    dependencies = { "tpope/vim-projectionist" },
    cond = function ()
      return vim.fn.filereadable("Gemfile") == 1
    end,
  },

  {
    "tpope/vim-rails",
    event = "LazyFile",
    dependencies = { "tpope/vim-projectionist" },
    cond = function ()
      return vim.fn.filereadable("config/environment.rb") == 1
    end,
  },

  -- { "ecomba/vim-ruby-refactoring" },

  { "slim-template/vim-slim", ft = "slim" },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        slim = { "slim_lint" },
      },
    },
  },

  {
    "RRethy/nvim-treesitter-endwise",
    event = "LazyFile",
    ft = { "ruby", "lua", "bash" },
  },
}
