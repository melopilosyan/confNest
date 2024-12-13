local function toggle()
  require("oil")[vim.w.oil_openned and "close" or "open"]()
  vim.w.oil_openned = not vim.w.oil_openned
end

vim.keymap.set("n", "<M-\\>", toggle,
  { desc = "Toggle parent directory view (Oil) in current window" })
vim.keymap.set("n", "<S-M-\\>", function()
  vim.cmd("vsplit")
  toggle()
end, { desc = "Toggle parent directory view (Oil) in a vertical split" })

return {
  "stevearc/oil.nvim",
  lazy = true,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    function CustomOilBar()
      local path = vim.fn.expand("%"):gsub("oil://", "")
      return "   " .. vim.fn.fnamemodify(path, ":.")
    end

    local oil = require "oil"

    local function toggle_permissions()
      oil.set_columns(oil.pflag and { "icon" } or { "icon", "permissions" })
      oil.pflag = not oil.pflag
    end

    oil.setup {
      skip_confirm_for_simple_edits = true,
      columns = { "icon" },
      keymaps = {
        -- Disable these defaults
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-k>"] = false,
        ["<C-j>"] = false,

        ["<M-r>"] = "actions.refresh",
        ["<M-h>"] = "actions.select_split",
        ["gd"] = { toggle_permissions, desc = "Toggle <editable> file permissions 🔥" },
      },
      win_options = {
        winbar = "%{v:lua.CustomOilBar()}",
      },
      view_options = {
        show_hidden = true,
      },
    }
  end,
}
