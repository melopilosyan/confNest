return {
  "ahmedkhalf/project.nvim",
  event = "VeryLazy",

  -- https://github.com/ahmedkhalf/project.nvim#%EF%B8%8F-configuration
  opts = {
    manual_mode = false,

    -- What scope to change the directory, valid options are
    -- * global (default)
    -- * tab
    -- * win
    scope_chdir = "win",

    -- silent_chdir = false,
  },
}
