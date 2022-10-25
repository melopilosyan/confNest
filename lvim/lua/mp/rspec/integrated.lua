--- RSpec Integrated
-- Runs RSpec spec files and adds failure messages into the file buffer as diagnostic entries.
-- Remembers the last spec and can run it again when called outside of the spec buffer.

-- Current spec info
local spec = {
  cmd = { "bundle", "exec", "rspec", nil, "--format", "j" }, -- the nil spot is for the file path to be inserted
}
function spec:populate(path)
  self.path = path
  self.bufnr = vim.api.nvim_get_current_buf()
  self.cmd[4] = path
  self.cwd = vim.fn.getcwd() .. "/"
  self.cwd_length = #self.cwd + 1
end

-- Some local globals
local MAX_NOTIF_TIMEOUT_TO_COMPLETE_THE_TEST = 60 * 60 * 1000

local COVERAGE_LINE_REQEX = "Coverage report generated.*$"
local DROP_ERROR_CLASSES  = "RSpec::Expectations"
local SPEC_FILE_REGEX     = "_spec.rb$"
local FAILURE_STATUS      = "failed"
local VIRTUAL_TEXT        = "Failure"
local LINENR_REGEX        = ":(%d+)"
local NON_WS_REGEX        = "%S"
local DOUBLE_NL           = "\n\n"
local LOG                 = vim.log.levels
local NL                  = "\n"
local ES                  = ""
local DIAG = {
  source    = "RSpec",
  severity  = vim.diagnostic.severity.ERROR,
  namespace = vim.api.nvim_create_namespace("rspec.integrated"),
  config = {
    virtual_text = {
      format = function(_) return VIRTUAL_TEXT end,
    },
  },
}

-- Local references of functions
local format = string.format
local nvim_buf_get_lines = vim.api.nvim_buf_get_lines

local function parse_json(stdout)
  local ok, json = pcall(string.gsub, stdout[1], COVERAGE_LINE_REQEX, ES)
  if not ok then
    print(vim.inspect(stdout))
    error("RSpec: malformed stdout:", json)
  end

  local result
  ok, result = pcall(vim.json.decode, json)
  if not ok then
    print(json)
    error("RSpec: invalid json format:", result)
  end

  return result
end

local function linenr_col(backtrace_line)
  local linenr = tonumber(backtrace_line:match(spec.path .. LINENR_REGEX))
  local line = nvim_buf_get_lines(spec.bufnr, linenr - 1, linenr, false)[1]
  local col = line:find(NON_WS_REGEX)

  return linenr, col
end

local function full_message(msg, klass, backtrace)
  local sep = msg:sub(1, 1) == NL and NL or DOUBLE_NL
  local msg_class = klass:find(DROP_ERROR_CLASSES) and ES or klass .. NL

  return format("%s%s%s%s%s", sep, msg_class, msg, sep, backtrace)
end

local function linenr_col_message(exception)
  local app_backtrace = "Backtrace:"
  local first_spec_record

  for _, record in ipairs(exception.backtrace) do
    -- Take only those records that come from the application files
    if record:find(spec.cwd) then
      if not first_spec_record and record:find(spec.path) then
        first_spec_record = record
      end

      app_backtrace = format("%s\n%s", app_backtrace, record:sub(spec.cwd_length, -1))
    end
  end

  local linenr, col = linenr_col(first_spec_record)
  local message = full_message(exception.message, exception.class, app_backtrace)

  return linenr, col, message
end

local function insert_failure(failures, linenr, col, message)
  table.insert(failures, {
    lnum     = linenr - 1,
    col      = col - 1,
    message  = message,
    source   = DIAG.source,
    severity = DIAG.severity,
  })
end

local function notify(msg, log_level, title, replace)
  return vim.notify(msg, log_level, {
    title   = "RSpec: " .. title,
    timeout = replace and 7000 or MAX_NOTIF_TIMEOUT_TO_COMPLETE_THE_TEST,
    replace = replace,
  })
end

local function notify_completed(message, succeeded, duration, replace, title)
  local log_level = succeeded and LOG.INFO or LOG.ERROR

  if succeeded then
    message = format("%s   (duration: %s)", message, duration)
  end
  title = title or (succeeded and "Succeeded" or "Failed")

  notify(message, log_level, title, replace)
end

local function process_output(result, notif)
  local summ = result.summary
  local failures = {}
  local notif_title

  if summ.errors_outside_of_examples_count > 0 then
    local message = table.concat(result.messages, ES)
    local linenr, col = linenr_col(message)

    insert_failure(failures, linenr, col, message)
    notif_title = "Error"

  elseif summ.example_count == 0 then
    notif_title = result.messages[1]

  elseif summ.failure_count == 0 then
    -- Shows success notification

  else
    local failure_lines = {}

    for _, example in ipairs(result.examples) do
      if example.status == FAILURE_STATUS then
        local linenr, col, message  = linenr_col_message(example.exception)

        -- Do not add multiple errors on the same line
        if not vim.tbl_contains(failure_lines, linenr) then
          table.insert(failure_lines, linenr)
          insert_failure(failures, linenr, col, message)
        end
      end
    end
  end

  vim.diagnostic.set(DIAG.namespace, spec.bufnr, failures, DIAG.config)

  notify_completed(result.summary_line, failures[1] == nil, summ.duration, notif, notif_title)
end

local M = {}

--- To be used in a mapping
-- nnoremap <leader>ti <cmd>lua require('mp.rspec.integrated').run()<cr>
function M.run()
  local path = vim.fn.expand("%:.")
  local is_spec = path:find(SPEC_FILE_REGEX)

  if not (is_spec or spec.path) then return end

  if is_spec and spec.path ~= path then
    spec:populate(path)
  end

  vim.cmd("silent! w")

  local notif = notify(table.concat(spec.cmd, " "), LOG.WARN, "Running...")

  vim.fn.jobstart(spec.cmd, {
    cwd = spec.cwd,
    stdout_buffered = true,
    on_stdout = function(_, output)
      process_output(parse_json(output), notif)
    end
  })
end

return M
