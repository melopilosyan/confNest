return {
  {
    "catgoose/nvim-colorizer.lua",
    cmd = "ColorizerToggle",
    opts = {
      options = {
        parsers = {
          tailwind = {
            enable = true,
            lsp = {
              enable = true,
              disable_document_color = true, -- default
            },
            update_names = false,
          },
        },
        display = {
          mode = "virtualtext", -- string or list: "background"|"foreground"|"underline"|"virtualtext"
          background = {
            bright_fg = "#000000", -- text color on bright backgrounds
            dark_fg = "#ffffff", -- text color on dark backgrounds
          },
          virtualtext = {
            char = "", -- character used for virtualtext
            position = "before", -- "eol"|"before"|"after"
            hl_mode = "foreground", -- "background"|"foreground"
          },
        },
      },
    },
  },
}
