local M = {}

local _, builtin = pcall(require, "telescope.builtin")
local _, themes = pcall(require, "telescope.themes")

local function deep_extent(t1, t2)
  return vim.tbl_deep_extend("force", t1, t2)
end

local function no_preview_dropdown(opts)
  return themes.get_dropdown(deep_extent(opts or {}, { previewer = false, hidden = true }))
end

function M.files_no_preview(opts)
  builtin.find_files(no_preview_dropdown(opts))
end

function M.word_under_cursor()
  builtin.grep_string { word_match = '-w', initial_mode = 'normal' }
end

function M.my_config_files()
  M.files_no_preview {
    sorting_strategy = "ascending",
    prompt_title = "~ My config files ~",
    cwd = "~/Projects/configs",
  }
end

-- @param symbol - Classes, Modules, Methods, ...
function M.lsp_workspace_symbols(symbol)
  builtin.lsp_workspace_symbols(no_preview_dropdown {
    symbols = symbol,
    prompt_title = "LSP Workspace Symbols / " .. symbol,
  })
end

return M
