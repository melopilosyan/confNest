local api = vim.api
local cmd = vim.cmd

local M = {}

local win = -1
local buf = -1

M.toggle = function()
  -- If the window exists, hide (effectively delete) it and return
  if api.nvim_win_is_valid(win) then
    return api.nvim_win_hide(win)
  end

  -- If buffer does not exist, create one as an unlisted "throwaway" |scratch-buffer|
  if not api.nvim_buf_is_valid(buf) then
    buf = api.nvim_create_buf(false, true)
  end

  -- Open top-level horizontal split below without number line and sign column
  win = api.nvim_open_win(buf, true, { split = "below", win = -1 })
  api.nvim_set_option_value("number", false, { win = win })
  api.nvim_set_option_value("relativenumber", false, { win = win })
  api.nvim_set_option_value("signcolumn", "no", { win = win })

  -- If the buffer is terminal, switch to insert mode and return
  if vim.bo[buf].buftype == "terminal" then
    return cmd("startinsert")
  end

  -- Open terminal and enter insert mode
  cmd("terminal")
  cmd("startinsert")

  -- Set to erase the scratch buffer when exiting the terminal, closing the window
  api.nvim_create_autocmd("TermClose", { buffer = buf, command = "bwipeout" })

  -- Hide the terminal buffer from buffers list
  api.nvim_set_option_value("buflisted", false, { scope = "local" })
end

return M
