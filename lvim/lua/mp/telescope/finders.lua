local builtin = require "telescope.builtin"
local themes = require "telescope.themes"

local M = { live_ripgrep = require("mp.telescope.live_ripgrep") }

local horizontal_top_prompt__options = {
  layout_strategy = "horizontal",
  layout_config = { prompt_position = "top", preview_width = 0.6, width = 0.97 },
  sorting_strategy = "ascending",
}

local function deep_extent(t1, t2, t3)
  if not t1 then return t2 end

  return vim.tbl_deep_extend("force", t1, t2, t3 or {})
end

local function no_preview_dropdown(opts)
  return themes.get_dropdown(deep_extent(opts, { previewer = false, hidden = true }))
end

local function horizontal_top_prompt(opts1, opts2)
  return deep_extent(opts1, horizontal_top_prompt__options, opts2)
end

local function grepper(opts)
  return opts and opts.grep_open_files and builtin.grep_string or M.live_ripgrep
end

local function selection()
  vim.cmd([[normal! "sy]])
  return vim.fn.getreg("s")
end

function M.selection_to_files_no_preview(opts)
  local path = vim.split(selection(), "/", { trimempty = true })
  local file_name = table.remove(path)
  local options = deep_extent(opts, { search_file = file_name, initial_mode = "normal" })
  M.files_no_preview(options)
end

function M.files_no_preview(opts)
  builtin.find_files(no_preview_dropdown(opts))
end

function M.word_under_cursor(opts)
  grepper(opts)(horizontal_top_prompt({
    word_match = "-w",
    initial_mode = "normal",
  }, opts))
end

function M.selection(opts)
  grepper(opts)(horizontal_top_prompt({
    search = selection(),
    word_match = opts and opts.word_match and "-w" or nil,
    initial_mode = "normal",
  }, opts))
end

function M.my_config_files()
  M.files_no_preview {
    sorting_strategy = "ascending",
    prompt_title = "~ My config files ~",
    cwd = vim.env.CONFIGS_DIR,
  }
end

-- @param symbol - Classes, Modules, Methods, ...
function M.lsp_workspace_symbols(symbol)
  builtin.lsp_workspace_symbols(no_preview_dropdown {
    symbols = symbol,
    prompt_title = "LSP Workspace Symbols / " .. symbol,
  })
end

function M.git_commits(opts)
  local commits = opts and opts.file and builtin.git_bcommits or builtin.git_commits
  commits(horizontal_top_prompt({ initial_mode = "normal" }))
end

function M.live_grep(opts)
  grepper(opts)(horizontal_top_prompt(opts))
end

function M.git_status()
  builtin.git_status(horizontal_top_prompt({ initial_mode = "normal" }))
end

return M
