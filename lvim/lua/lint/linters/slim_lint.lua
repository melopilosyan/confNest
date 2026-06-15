local severity_map = {
  error = vim.diagnostic.severity.ERROR,
  warning = vim.diagnostic.severity.WARN,
}

return {
  cmd = "slim-lint",
  stdin = true,
  args = {
    "--reporter",
    "json",
    "--stdin-file-path",
    function() return vim.api.nvim_buf_get_name(0) end,
  },
  ignore_exitcode = true,
  parser = function(output)
    ---@type vim.Diagnostic[]
    local diagnostics = {}
    local decoded = vim.json.decode(output)

    if not decoded.files[1] then
      return diagnostics
    end

    local offences = decoded.files[1].offenses

    for _, off in pairs(offences) do
      table.insert(diagnostics, {
        source = "slim-lint",
        lnum = off.location.line - 1,
        col = 0,
        end_col = math.huge,
        severity = severity_map[off.severity],
        message = off.message,
        code = off.linter == vim.NIL and "slim-lint" or off.linter,
      })
    end

    return diagnostics
  end,
}
