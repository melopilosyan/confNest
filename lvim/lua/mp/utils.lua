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

return M
