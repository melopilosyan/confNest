local M = {}

local MODE_HEADINGS = {
  n = "## Normal mode",
  v = "## Visual mode",
  i = "## Insert mode",
  t = "## Terminal mode",
}

local function concat(lhs, desc)
  return string.format("%-10s ", lhs) .. desc
end

local map = setmetatable({ keymaps = {} }, {
  __index = function(self, mode)
    self[mode] = function(lhs, rhs, opts)
      local desc = opts or rhs
      if type(opts) == "table" then desc = opts.desc end

      table.insert(self.keymaps[mode], concat(lhs, desc))
    end

    self.keymaps[mode] = {}
    return self[mode]
  end
})

-- Add the dummy (for decumentaion) mappings here
map.n("<M-\\>", "", "Toggle parent directory view (Oil) in current window")
map.n("<S-M-\\>", "", "Open parent directory view (Oil) in current window")

map.n("<C-s>", "", "Save the session for the CWD")
map.n("<C-S-s>", "", "Load the session for the CWD")

local function set_other_keymaps(buf, mode)
  local mappings = vim.api.nvim_get_keymap(mode)
  local devider = true

  for _, m in ipairs(mappings) do
    local first_char = m.lhs and string.sub(m.lhs, 1, 1)
    if m.desc and first_char ~= " " and first_char ~= "<" and first_char ~= m.lhs then
      if devider then vim.api.nvim_buf_set_lines(buf, -1, -1, true, { "   - - - - -" }) end
      vim.api.nvim_buf_set_lines(buf, -1, -1, true, { concat(m.lhs, m.desc) })
      devider = false
    end
  end
end

function M.show_keymaps()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_open_win(buf, true, { split = "right", win = -1 })

  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, { "# Keymaps" })

  for mode, keymaps in pairs(map.keymaps) do
    vim.api.nvim_buf_set_lines(buf, -1, -1, true, { "", MODE_HEADINGS[mode] })
    vim.api.nvim_buf_set_lines(buf, -1, -1, true, keymaps)
    set_other_keymaps(buf, mode)
  end
end

M.map = map
return M
