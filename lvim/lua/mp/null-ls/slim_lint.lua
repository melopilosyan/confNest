local null_ls = require("null-ls")
local h = require("null-ls.helpers")

local parser = h.diagnostics.from_json {
  severities = {
    info = h.diagnostics.severities.information,
    warning = h.diagnostics.severities.warning,
    error = h.diagnostics.severities.error,
    fatal = h.diagnostics.severities.fatal,
  },
}

local function handle_output(params)
  if not (params.output and params.output.files) then return {} end

  local file = params.output.files[1]
  if not (file and file.offenses) then return {} end

  local offenses = {}

  for _, offense in ipairs(file.offenses) do
    table.insert(offenses,  {
      message = offense.message,
      ruleId = offense.linter,
      level = offense.severity,
      line = offense.location.line,
    })
  end

  return parser { output = offenses }
end

return function()
  null_ls.register {
    name = "slim-lint",
    filetypes = { "slim" },
    method = null_ls.methods.DIAGNOSTICS,
    generator = null_ls.generator({
      command = "slim-lint",
      args = { "--reporter", "json", "--stdin-file-path", "$FILENAME" },
      to_stdin = true,
      from_stderr = true,
      format = "json",
      check_exit_code = function(code)
        return code <= 1
      end,
      on_output = handle_output,
    }),
  }
end
