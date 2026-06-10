local ok, ColorScheme = pcall(require, "current_colorscheme")
if not ok then ColorScheme = "tokyonight" end

return {
  {
    "shaunsingh/nord.nvim",
    lazy = true,
    init = function ()
      -- Make sidebars and popup menus like nvim-tree and telescope have a different background
      vim.g.nord_contrast = true
      -- Enable the border between verticaly split windows visable
      vim.g.nord_borders = false
      -- Disable the setting of background color so that NeoVim can use your terminal background
      vim.g.nord_disable_background = true
      -- Set the cursorline transparent/visible
      vim.g.nord_cursorline_transparent = false
      -- Re-enables the background of the sidebar if you disabled the background of everything
      vim.g.nord_enable_sidebar_background = false
      -- Enables/disables italics
      vim.g.nord_italic = true
      -- Enables/disables colorful backgrounds when used in diff mode
      vim.g.nord_uniform_diff_background = true
      -- Enables/disables bold
      vim.g.nord_bold = true
    end
  },
  {
    "akinsho/bufferline.nvim",
    opts = function(_, opts)
      if ColorScheme == "nord" then
        opts.highlights = require("nord").bufferline.highlights({
          italic = false,
          bold = true,
          fill = "#181c24"
        })
      end
    end,
  },

  {
    "neanias/everforest-nvim",
    lazy = true,
  },

  {
    "folke/tokyonight.nvim",
    lazy = true,
    opts = {
      style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
      transparent = false, -- Enable this to disable setting the background color
      terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
      styles = {
        -- Style to be applied to different syntax groups
        -- Value is any valid attr-list value for `:help nvim_set_hl`
        comments = { italic = true },
        keywords = {},
        functions = {},
        variables = { italic = true },
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "dark", -- style for sidebars, see below
        floats = "dark", -- style for floating windows
      },

      on_colors = function(c)
        c.fg_dark = "#828bb8"
        c.blue5 = "#89ddff"
        c.bg_statusline = "none"
      end,

      on_highlights = function(hl)
        --- TODO: make it work
        -- hl["@variable.builtin"].style = { italic = true }
        -- hl["@variable.member"].style = { italic = true }

        hl.DiagnosticVirtualTextError.bg = "none"
        hl.DiagnosticVirtualTextWarn.bg = "none"
        hl.DiagnosticVirtualTextInfo.bg = "none"
        hl.DiagnosticVirtualTextHint.bg = "none"
      end,
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    opts = { theme = ColorScheme },
  },

  {
    "LazyVim/LazyVim",
    opts = { colorscheme = ColorScheme },
  }
}
