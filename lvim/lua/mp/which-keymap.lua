local M = {}

local MODE_HEADINGS = {
  n = "## Normal mode",
  v = "## Visual mode",
  i = "## Insert mode",
  t = "## Terminal mode",
}

local function concat(mode, lhs, desc)
  return string.format("%s  %-10s %s", mode, lhs, desc)
end
print(concat("n", "lhs", "desc"))

-- Takes over the map in plugin/keymaps.lua
local map = setmetatable({
  keymaps = {},
  group = function(self, title)
    table.insert(self.keymaps, "")
    table.insert(self.keymaps, "### " .. title)
  end
}, {
  __index = function(self, mode)
    self[mode] = function(lhs, rhs, opts)
      local desc = opts or rhs
      if type(opts) == "table" then desc = opts.desc end

      table.insert(self.keymaps, concat(mode, lhs, desc))
    end

    return self[mode]
  end
})

-- Mappings that are defined outside of plugin/keymaps.lua
-- and can't be easily taken programmatically.
local function add_mappings_defined_elsewhere()
  map:group "Accessing Oil file manager -- mp/plugins/oil.lua"
  map.n("<M-\\>", "", "Toggle parent directory view (Oil) in current window")
  map.n("<S-M-\\>", "", "Open parent directory view (Oil) in current window")

  map:group "Session management -- after/plugin/sessions.lua"
  map.n("<C-s>", "", "Save the session for the CWD")
  map.n("<C-S-s>", "", "Load the session for the CWD")

  map:group "tpope/vim-surround - closing pairs no space :)"
  map.n("cs", "Change surrounding")
  map.n("ds", "Delete the surrounding")
  map.n("ys", "Surround")
  map.n("yss", "Surround current line")

  map:group "ggandor/leap.nvim -- :help leap-mappings"
  map.n("s", "Leap forward")
  map.n("S", "Leap backward")
  map.n("gs", "Leap from window")

  map:group "Treesitter incremental selection"
  map.n("<cr>", "Initialize selection")
  map.n("<cr>", "Increment")
  map.n(",", "Decrement")

  map:group "Nvim-cmp mappings"
  map.n("<C-b>", "Scroll docs backward")
  map.n("<C-f>", "Scroll docs forward")
  map.i("<C-s>", "Expand or jump")
  map.i("<C-e>", "Change choice")
  map.n("<C-a>", "Abort")
end

local function include_other_keymaps(buf, mode, heading)
  local mappings = vim.api.nvim_get_keymap(mode)
  local show_heading = true

  for _, m in ipairs(mappings) do
    local first_char = m.lhs and string.sub(m.lhs, 1, 1)

    if m.desc and first_char ~= " " and first_char ~= "<" and first_char ~= m.lhs then
      if show_heading then
        vim.api.nvim_buf_set_lines(buf, -1, -1, true, { "", heading })
      end

      vim.api.nvim_buf_set_lines(buf, -1, -1, true, { concat(mode, m.lhs, m.desc) })
      show_heading = false
    end
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
  vim.api.nvim_buf_set_lines(buf, -1, -1, true, map.keymaps)

  for mode, heading in pairs(MODE_HEADINGS) do
    include_other_keymaps(buf, mode, heading)
  end

  map.keymaps = {}
end

M.map = map
return M
