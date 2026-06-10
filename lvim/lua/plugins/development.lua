return {
  {
    "melopilosyan/rspec-integrated.nvim",
    lazy = true,
    dev = false,
  },

  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gread", "Gwrite", "Gvdiffsplit" }
  },
  { "tpope/vim-repeat", event = "VeryLazy" },
  { "tpope/vim-surround", event = "VeryLazy" },

  {
    "tpope/vim-rake",
    dependencies = { "tpope/vim-projectionist" },
    ft = { "ruby" }
  },

  {
    "tpope/vim-bundler",
    dependencies = { "tpope/vim-projectionist" },
    cond = function ()
      return vim.fn.filereadable("Gemfile") == 1
    end,
  },

  {
    "tpope/vim-rails",
    dependencies = { "tpope/vim-projectionist" },
    cond = function ()
      return vim.fn.filereadable("config/environment.rb") == 1
    end,
  },

  -- { "ecomba/vim-ruby-refactoring" },

  { "slim-template/vim-slim", ft = "slim" },

  {
    "RRethy/nvim-treesitter-endwise",
    event = "VeryLazy",
    ft = { "ruby", "lua", "bash" },
  },
}
