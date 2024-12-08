local group = vim.api.nvim_create_augroup("general.clear", {})
local autocmd = vim.api.nvim_create_autocmd

---@param opts vim.api.keyset.create_autocmd
local function autocmd_clear(event, opts)
  opts.group = group
  autocmd(event, opts)
end

autocmd_clear("FocusLost", {
  desc = "Save all buffers",
  command = "wa",
})

autocmd_clear("BufReadPost", {
  desc = "Set the cursor to the last position in the file",
  callback = function()
    local linenr = vim.fn.line("'\"")
    if linenr > 1 and linenr <= vim.fn.line("$") then
      vim.cmd "normal! g`\""
    end
  end
})

autocmd_clear("BufWritePre", {
  desc = "Remove trailing whitespaces",
  command = "%s/\\s\\+$//e",
})

autocmd_clear({ "BufNewFile", "BufRead" }, {
  desc = "Annotate empty Ruby files with `frozen_string_literal: true`",
  pattern = { "*.rb", "*.rake" },
  callback = vim.schedule_wrap(function()
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
    if first_line == "" then
      vim.api.nvim_buf_set_lines(0, 0, 1, false, { "# frozen_string_literal: true", "", "" })
      vim.api.nvim_win_set_cursor(0, { 3, 0 })
    end
  end),
})

autocmd_clear("FileType", {
  desc = "Add ! and ? to the keyword character list for Ruby files",
  pattern = { "ruby", "eruby", "slim" },
  command = "setlocal iskeyword+=!,?",
})

autocmd_clear("FileType", {
  desc = "Rails.vim changes YAML files type to eruby.yaml. Set it back to yaml",
  pattern = "eruby.yaml",
  command = "setlocal filetype=yaml",
})

autocmd("FileType", {
  desc = "Register slim-lint as null-ls diagnostics entry",
  once = true,
  pattern = "slim",
  callback = function() vim.schedule(require("mp.null-ls.slim_lint")) end,
})
