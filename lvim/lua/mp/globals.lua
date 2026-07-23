P = function(v)
  print(vim.inspect(v))
  return v
end

RELOAD = function(...)
  return require("plenary.reload").reload_module(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end

-- https://github.com/tjdevries/lazy-require.nvim/blob/master/lua/lazy-require.lua#L25
_G.lazy_require = function(require_path)
  return setmetatable({}, {
    __index = function(_, key)
      return require(require_path)[key]
    end,
  })
end

local api = vim.api
local win = -1
local buf = -1

_G.write_in_a_split_window = function(data)
  if not api.nvim_buf_is_valid(buf) then
    -- Create one as an unlisted "throwaway" |scratch-buffer|
    buf = api.nvim_create_buf(false, true)
    vim.keymap.set("n", "q", ":bwipeout<cr>", { buf = buf })
  end

  if not api.nvim_win_is_valid(win) then
    -- Open top-level right split without number line and sign column
    win = api.nvim_open_win(buf, true, { split = "right", win = -1 })
    -- api.nvim_set_option_value("number", false, { win = win })
    api.nvim_set_option_value("relativenumber", false, { win = win })
    api.nvim_set_option_value("signcolumn", "no", { win = win })
  end

  vim.schedule(function()
    local lines = vim.split(vim.inspect(data), "\n", { plain = true })
    api.nvim_buf_set_lines(buf, -1, -1, false, lines)
  end)
end

_G.playground = {
  data = {},
  collect = function(self, data)
    if self.stoppped then return end
    table.insert(self.data, data)
  end,
  write = function(self, data)
    if self.stopped then return end
    write_in_a_split_window(data)
  end,
  stop = function(self)
    self.stoppped = true
  end,
  reset = function(self)
    self.data = {}
    self.stoppped = false
  end,
  write_data = function(self)
    write_in_a_split_window(self.data)
  end,
}
