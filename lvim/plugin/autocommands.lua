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

local function cursor_on_image()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 1-indexed

  local regexes = {
    "()!%[.-%]%(.-%)()", -- Markdown image: ![alt](path)
    "()<img.-src%s*=.->()", -- HTML img tag: <img ... src="..." ...>
  }

  for _, reg in ipairs(regexes) do
    for match_start, match_end in line:gmatch(reg) do
      if col >= match_start and col < match_end then
        return true
      end
    end
  end

  return false
end

autocmd_clear("LspAttach", {
  desc = "Handle markdown <K> show inline image after lsp attach",
  callback = function(ev)
    if vim.bo[ev.buf].filetype ~= "markdown" then return end
    -- Wait until LazyVim finishes attaching lsp callbacks to override its K mapping
    vim.defer_fn(function()
      vim.keymap.set("n", "K", function()
        if cursor_on_image() then
          Snacks.image.hover()
        else
          vim.lsp.buf.hover()
        end
      end, { buf = ev.buf, desc = "Show images inline" })
    end, 600)
  end,
})
