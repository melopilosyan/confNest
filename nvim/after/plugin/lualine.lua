local required, lualine = pcall(require, 'lualine')
if not required then
  return
end

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
    globalstatus = false,
  },
  sections = {
    lualine_a = {
      'mode',
    },
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {
    -- lualine_a = {
    --   {
    --     'buffers',
    --     show_filename_only = true,   -- Shows shortened relative path when set to false.
    --     show_modified_status = true, -- Shows indicator when the buffer is modified.

    --     mode = 0, -- 0: Shows buffer name
    --               -- 1: Shows buffer index (bufnr)
    --               -- 2: Shows buffer name + buffer index (bufnr)

    --     max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
    --     -- it can also be a function that returns
    --     -- the value of `max_length` dynamically.
    --     filetype_names = {
    --       TelescopePrompt = 'Telescope',
    --       dashboard = 'Dashboard',
    --     }, -- Shows specific buffer name for that filetype ( { `filetype` = `buffer_name`, ... } )

    --     buffers_color = {
    --       -- Same values as the general color option can be used here.
    --       -- active = 'lualine_{section}_normal',     -- Color for active buffer.
    --       active = function(section)
    --          return { fg = vim.bo.modified and '#aa3355' or '#33aa88' }
    --       end,
    --       inactive =function(section)
    --          return { fg = vim.bo.modified and '#aa3355' or '#33aa88' }
    --        end,
    --     },
    --   },
    -- },
  },
  extensions = {}
}
