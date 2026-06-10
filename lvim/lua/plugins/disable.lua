-- Disable LazyVim defaults
return {
  { "folke/noice.nvim", enabled = false },
  { "folke/persistence.nvim", enabled = false },
  { "MagicDuck/grug-far.nvim", enabled = false },

  {
    "snacks.nvim",
    opts = {
      indent = { enabled = false },
      dashboard = { enabled = false },
    },
  },

  {
    "folke/flash.nvim",
    opts = {
      modes = {
        char = {
          keys = {},
        }
      },
    }
  },

  {
    "folke/todo-comments.nvim",
    keys = {
      { "<leader>xt", false },
      { "<leader>xT", false },
    }
  },

  {
    "folke/trouble.nvim",
    keys = {}
  },
}
