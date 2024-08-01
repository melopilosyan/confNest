local ok, ColorScheme = pcall(require, "current_colorscheme")
if not ok then ColorScheme = "tokyonight" end

local M = {}

function M.is(test)
  return ColorScheme == test
end

function M.selected(name, lualine_theme)
  local enable = ColorScheme == name

  if enable then
    lvim.colorscheme = name
    lvim.builtin.lualine.options.theme = lualine_theme or name
  end

  return enable
end

return M
