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

-- Takes over the map in plugin/keymaps.lua
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

-- Mappings that are defined outside of plugin/keymaps.lua
-- and can't be easily taken programmatically.
local function add_mappings_defined_elsewhere()
  -- mp/plugins/oil.lua
  map.n("<M-\\>", "", "Toggle parent directory view (Oil) in current window")
  map.n("<S-M-\\>", "", "Open parent directory view (Oil) in current window")

  -- after/plugin/sessions.lua
  map.n("<C-s>", "", "Save the session for the CWD")
  map.n("<C-S-s>", "", "Load the session for the CWD")
end

local function include_other_keymaps(buf, mode)
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

local function clear_keymaps()
  for mode, _ in pairs(map.keymaps) do
    map.keymaps[mode] = {}
  end
end

local function create_buffer_in_right_split()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>bwipeout<cr>", {})

  vim.api.nvim_open_win(buf, true, { split = "right", win = -1 })

  return buf
end

function M.show_keymaps()
  add_mappings_defined_elsewhere()

  local buf = create_buffer_in_right_split()

  vim.api.nvim_buf_set_lines(buf, 0, -1, true, { "# Keymaps" })
  for mode, keymaps in pairs(map.keymaps) do
    vim.api.nvim_buf_set_lines(buf, -1, -1, true, { "", MODE_HEADINGS[mode] })
    vim.api.nvim_buf_set_lines(buf, -1, -1, true, keymaps)
    include_other_keymaps(buf, mode)
  end

  clear_keymaps()
end

M.map = map
return M
