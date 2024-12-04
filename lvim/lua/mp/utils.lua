local M = {}

local FT_TO_CMD = {
  lua = "source %",
  sh = "!source %",
  ruby = "!ruby %",
}

function M.run_current_file()
  local cmd = FT_TO_CMD[vim.bo.filetype]

  if not cmd then
    print "Not supported file type"
  else
    vim.cmd(cmd)
  end
end

local FT_TO_SELECTION_CMD = {
  lua = ":lua<cr>",
  sh = ":w !bash<cr>",
  ruby = ":w !ruby<cr>",
}

function M.run_selection_cmd()
  return FT_TO_SELECTION_CMD[vim.bo.filetype] or ":"
end

return M
