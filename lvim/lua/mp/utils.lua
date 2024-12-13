local M = {}

local FILE_RUNNERS = {
  lua = "source %",
  sh = "!source %",
  ruby = "!ruby %",
}

local PARTIAL_RUNNERS = {
  lua = "lua",
  sh = "w !bash",
  ruby = "w !ruby",
}

local function runner_cmd(runners, prefix)
  local cmd = runners[vim.bo.filetype]
  return cmd and prefix .. cmd .. "<cr>"
end

function M.file_runner_cmd()
  vim.cmd("silent! w")
  return runner_cmd(FILE_RUNNERS, ":")
end

function M.line_runner_cmd()
  return runner_cmd(PARTIAL_RUNNERS, ":.")
end

function M.selection_runner_cmd()
  return runner_cmd(PARTIAL_RUNNERS, ":")
end

return M
