local function save_the_paths(ksb_dir)
  local kitten_path = ksb_dir .. "/python/kitty_scrollback_nvim.py"
  local kitten_args = string.format(
    "--env NVIM_APPNAME=%s --nvim-args -n -u %s",
    vim.env.NVIM_APPNAME or "nvim",
    vim.env.CONFIGS_DIR .. "/kitty/scrollback-config.lua"
  )

  -- Defines the scrollback_nvim action alias for kitty. Included in ~/.config/kitty/kitty.conf
  vim.fn.writefile(
    string.format("action_alias scrollback_nvim kitten %s %s", kitten_path, kitten_args),
    vim.fs.normalize("~/.config/kitty/scrollback-nvim.conf")
  )
  -- Configures the command line editing (<C-x><C-e>). Sourced from bash/bashrc
  vim.fn.writefile({
    'export KITTY_SCROLLBACK_VISUAL="$VISUAL"',
    'export KITTY_SCROLLBACK_NVIM_EDIT_ARGS="' .. kitten_args .. '"',
    "export VISUAL=" .. ksb_dir .. "/scripts/edit_command_line.bash",
  }, vim.fs.normalize("~/.kitty_edit_command_line_envs.sh"))
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
    save_the_paths(plugin.dir)
  end,
  opts = {
    -- The configuration is in kitty/scrollback-config.lua
  },
}
