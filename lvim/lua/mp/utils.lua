local M = {}

local function bin_rails_is_executable()
  if vim.b.inside_rails == nil then
    vim.b.inside_rails = vim.fn.executable("bin/rails") == 1
  end
  return vim.b.inside_rails
end

local FILE_RUNNERS = {
  lua = "source %",
  sh = "!source %",
  ruby = function ()
    if bin_rails_is_executable() then
      return "!bin/rails runner %"
    end
    return "!ruby %"
  end,
}

local PARTIAL_RUNNERS = {
  lua = "lua",
  sh = "w !bash",
  ruby = function ()
    if bin_rails_is_executable() then
      return "w !bin/rails runner -"
    end
    return "w !ruby"
  end,
}

local function runner_cmd(runners, prefix)
  local cmd = runners[vim.bo.filetype]
  if type(cmd) == "function" then cmd = cmd() end

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
