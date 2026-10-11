local function build_scrollback_alias(plugin_dir)
  vim.fn.writefile(
    string.format(
      "action_alias scrollback_nvim kitten %s --env NVIM_APPNAME=%s --nvim-args -n -u %s",
      plugin_dir .. "/python/kitty_scrollback_nvim.py",
      vim.env.NVIM_APPNAME or "nvim",
      vim.env.CONFIGS_DIR .. "/kitty/scrollback-config.lua"
    ),
    vim.fs.normalize("~/.config/kitty/scrollback-nvim.conf")
  )
end

return {
  "mikesmithgh/kitty-scrollback.nvim",
  enabled = true,
  lazy = true,
  cmd = {
    "KittyScrollbackGenerateKittens",
    "KittyScrollbackCheckHealth",
    "KittyScrollbackGenerateCommandLineEditing",
  },
  event = { "User KittyScrollbackLaunch" },
  build = function(plugin)
    build_scrollback_alias(plugin.dir)
  end,
  opts = {
    -- The configuration is in kitty/scrollback-config.lua
  },
}
