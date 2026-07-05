return {
  "folke/snacks.nvim",
  optional = true,
  keys = {
    {
      "<leader>e", function()
        Snacks.explorer({ cwd = vim.uv.cwd() })
      end, desc = "Explorer Snacks (cwd)",
    },
    {
      "<leader>E", function()
        Snacks.explorer({ cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) })
      end, desc = "Explorer Snacks (dir)",
    },
    { "<leader>fe", false },
    { "<leader>fE", false },
  },
}
