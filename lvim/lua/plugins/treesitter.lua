return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "ruby",
        "lua",
        "bash",
        "javascript",
        "json",
        "css",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<cr>",
          node_incremental = "<cr>",
          node_decremental = ",",
        },
      },
      -- endwise = { enable = true },
    },
  },
}
