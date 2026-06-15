return {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gread", "Gwrite", "Gvdiffsplit" }
  },
  { "tpope/vim-repeat", event = "LazyFile" },
  { "tpope/vim-surround", event = "LazyFile" },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_SplitWidth = 25
      vim.g.undotree_HelpLine = 0
    end
  },

  {
    "folke/twilight.nvim",
    cmd = "Twilight",
    opts = {}, -- configuration https://github.com/folke/twilight.nvim#%EF%B8%8F-configuration
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opts = {}, -- configuration https://github.com/folke/zen-mode.nvim#%EF%B8%8F-configuration
  },
}
