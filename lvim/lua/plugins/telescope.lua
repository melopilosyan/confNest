
return {
  "nvim-telescope/telescope.nvim",
  opts = {
    defaults = {
      prompt_prefix = "🔎 ",
      preview = {
        mime_hook = function (filepath, bufnr, _)
          local mime = vim.fn.system({ "file", "--mime-type", "-b", filepath })
          if  not vim.startswith(mime, "image/") then return true end

          pcall(vim.api.nvim_buf_set_lines, bufnr, 0, -1, false, {})
          Snacks.image.buf.attach(bufnr, { src = filepath })
          return false
        end,
      },
    },
  },
  keys = {
    { "<leader><space>", false },
    { "<leader>,", false },
    { "<leader>fB", false },
    { "<leader>ff", false },
    { "<leader>fF", false },
    { "<leader>fc", false },
    { "<leader>fC", false },
    { "<leader>fg", false },
    { "<leader>gl", false },
    { "<leader>fp", false },
    { "<leader>gs", false },
    { "<leader>gS", false },
    { "<leader>sc", false },
    { "<leader>sw", false },
    { "<leader>sW", false },
    { "<leader>sw", mode = "x", false },
    { "<leader>sW", mode = "x", false },
    { "<leader>uC", false },
    { "<leader>/", false },
  },
}
