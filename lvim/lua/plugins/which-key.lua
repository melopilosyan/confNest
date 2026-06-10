return {
  {
    "folke/which-key.nvim",
    opts = function(_, opts)
      local spec = opts.spec[1]
      local delete_groups = {
        ["<leader>w"] = 1, -- windows
        ["<leader>q"] = 1, -- quite
        ["<leader>x"] = 1, -- diagnostics/quickfix
      }

      for i = #spec, 1, -1 do
        local group = spec[i][1]
        if delete_groups[group] then
          table.remove(spec, i)
        end
      end

      table.insert(spec, { "<leader>t", group = "Test" })
      table.insert(spec, { "<leader>r", group = "Rails navigation/Run" })

      opts.delay = 700
      return opts
    end,
  }
}
