return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",

  -- https://github.com/lewis6991/gitsigns.nvim#%EF%B8%8F-installation--usage
  opts = {
    preview_config = {
    -- Options passed to nvim_open_win
      border = "rounded",
      title = " Git Commit ",
      title_pos = "center",
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },
  },
}
