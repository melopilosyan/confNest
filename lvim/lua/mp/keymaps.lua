local set = vim.keymap.set

---@alias KMapFun fun(lhs: string, rhs: string|function, opts?: string|vim.keymap.set.Opts)

---@class KeymapSet
---@field i KMapFun Add insert mode mappings
---@field n KMapFun Add normal mode mappings
---@field v KMapFun Add visual mode mappings
---@field x KMapFun Add visual block mode mappings
---@field c KMapFun Add command mode mappings
---@field o KMapFun Add operator pending mode mappings
---@field t KMapFun Add terminal mode mappings
---@field group fun(self: KeymapSet, title: string) Used for documentation. See mp/which-keymap.lua
local map = setmetatable({ opts = { noremap = true, silent = true }, group = function() end }, {
  __call = function(self, mode, lhs, rhs, opts)
    if opts then
      opts = type(opts) == "string" and { desc = opts } or opts
      opts.noremap = true
    end
    set(mode, lhs, rhs, opts or self.opts)
  end,
  __index = function(self, mode)
    self[mode] = function(lhs, rhs, opts)
      self(mode, lhs, rhs, opts)
    end
    return self[mode]
  end,
})

if _G.__show_keymaps then map = R("mp.which-keymap").map end

map:group("Save file")
map.n("<leader>w", "<cmd>w<cr>", "Save buffer")
map.n("<leader>W", "<cmd>wa<cr>", "Save all buffers")
map.n("<leader>q", "<cmd>q<cr>", "Quit")
map.n("<leader>x", "<cmd>x<cr>", "Save and quit")
map.n("<leader>X", "<cmd>xa<cr>", "Save and quit all")

map:group "Buffer navigation"
map.n("L", "<cmd>BufferLineCycleNext<cr>")
map.n("H", "<cmd>BufferLineCyclePrev<cr>")

map:group "Window navigation"
map.n("<C-l>", "<C-w>l", "Move to the left window")
map.n("<C-h>", "<C-w>h", "Move to the right window")
map.n("<C-k>", "<C-w>k", "Move to the top window")
map.n("<C-j>", "<C-w>j", "Move to the bottom window")

map:group "Tab navigation"
map.n("<M-l>", "gt", "Move to the next tab page")
map.n("<M-h>", "gT", "Move to the previous tab page")

map:group "Terminal window navigation"
map.t("<C-l>", "<C-\\><C-N><C-w>l", "Move to the left window")
map.t("<C-h>", "<C-\\><C-N><C-w>h", "Move to the right window")
map.t("<C-k>", "<C-\\><C-N><C-w>k", "Move to the top window")
map.t("<C-j>", "<C-\\><C-N><C-w>j", "Move to the bottom window")

map.t("<Esc>", "<C-\\><C-N>", "Esc in terminal window properly")

map:group "Window resizing"
map.n("<M-w>", "<C-w>3+", "Make the window taller")
map.n("<M-s>", "<C-w>3-", "Make the window shorter")
map.n("<M-,>", "<C-w>3<", "Make the window narrower")
map.n("<M-.>", "<C-w>3>", "Make the window wider")

map:group "Move the current line/block"
map.i("<M-k>", "<Esc>:m .-2<cr>==gi", "Move the line up")
map.i("<M-j>", "<Esc>:m .+1<cr>==gi", "Move the line down")
map.n("<M-k>", "<cmd>m .-2<cr>==", "Move the line up")
map.n("<M-j>", "<cmd>m .+1<cr>==", "Move the line down")
map.v("<M-k>", ":m '<-2<cr>gv-gv", "Move the line/block up")
map.v("<M-j>", ":m '>+1<cr>gv-gv", "Move the line/block down")

map:group "Move through and toggle the quickfix list"
map.n("]q", "<cmd>cnext<cr>")
map.n("[q", "<cmd>cprev<cr>")
map.n("<C-q>", function()
  local wininfo = vim.fn.getwininfo(vim.fn.win_getid())
  vim.cmd(wininfo[#wininfo].quickfix == 1 and "cclose" or "copen")
end, "Toggle quickfix window per tab page")

map:group "Center(zz) and expand folds(zv) of a search match"
map.n("n", "nzzzv")
map.n("N", "Nzzzv")

map:group "Toggle plugins"
-- map.n("\\", "<cmd>NvimTreeToggle<cr>")
map.n("<F5>", "<cmd>UndotreeToggle<cr>")
map.n("<F4>", "<cmd>Twilight<cr>")
map.n("<F8>", "<cmd>ZenMode<cr>")

map:group "Stay in visual mode during indentation"
map.v("<", "<gv")
map.v(">", ">gv")

map:group "Don't copy the selection on paste"
map.v("p", [["_dP]])

map:group "Copy/paste to/from the system clipboard"
map.n("gy", [["+y]])
map.n("gp", [["+p]])
map.v("gy", [["+y]])
map.v("gp", [["+p]])

local pick = function(command, opts)
  return function() require('mp.telescope.finders')[command](opts) end
end

map:group "GIT"
map.n("<leader>gB", "<cmd>Git blame<cr>", "Blame buffer")
map.n("<leader>gG", "<cmd>Git<cr>", "Git fugitive")
map.n("<leader>gg", "<cmd>Git commit<cr>", "Git commit")
map.n("<leader>gA", "<cmd>Git commit --amend<cr>", "Git commit --amend")
map.n("<leader>gP", "<cmd>Git push<cr>", "Git push")
map.n("<leader>gp", function () require("gitsigns").preview_hunk() end, "Preview hunk in popup")
map({ "n", "x" }, "<leader>gr", function () require("gitsigns").reset_hunk() end, "Reset hunk")
map.n("<leader>gl", function() require("gitsigns").blame_line({ full = true }) end, "Line blame")
map({ "n", "x" }, "<leader>gs", function () require("gitsigns").stage_hunk() end, "Stage hunk")
map.n("<leader>gS", function() require("gitsigns").stage_buffer() end, "Stage Buffer")
map.n("<leader>gj", function() require("gitsigns").nav_hunk("next", { target = "all" }) end, "Next hunk")
map.n("<leader>gk", function() require("gitsigns").nav_hunk("prev", { target = "all" }) end, "Previous hunk")
map.n("<leader>go", pick("git_status"), "Open changed files")
map.n("<leader>gC", pick("git_commits"), "Checkout commit")
map.n("<leader>gc", pick("git_commits", { file = true }), "Checkout commit(for current file)")

map:group "Pickers"
map.n("<leader><space>", pick("files_no_preview"), "Files no preview")
map.n("<leader>ff", pick("files"), "Files with preview")
map.n("<leader>fw", pick("word_under_cursor"), "Word under cursor")
map.n("<leader>fW", pick("word_under_cursor", { grep_open_files = true }), "Word under cursor in open files")
map.n("<leader>fp", pick("plugin_files"), "Plugin Files")
map.n("<leader>sp", pick("life_grep_plugin_files"), "Life grep in Plugin files")
map.n("<leader>fP", "<cmd>Telescope projects initial_mode=normal<cr>", "Projects")
map.n("<leader>ft", pick("live_grep"), "Text")
map.n("<leader>fT", pick("live_grep", { grep_open_files = true }), "Text in open files")
map.n("<leader>fC", pick("my_config_files"), "My config files")

map.v("<leader>ff", pick("selection_to_files_no_preview"), "Selection to files no preview")
map.v("<leader>fw", pick("selection", { word_match = true }), "Selection as word")
map.v("<leader>fW", pick("selection", { word_match = true, grep_open_files = true }), "Selection as word in open files")
map.v("<leader>ft", pick("selection"), "Selection as text")
map.v("<leader>fT", pick("selection", { grep_open_files = true }), "Selection as text in open files")

map:group "RSpec runners"
map.n("<leader>tI", function() require('rspec').run_current_file() end, "RSpec run current file")
map.n("<leader>ti", function() require('rspec').run_current_example() end, "RSpec run current example")
map.n("<leader>td", function() require('rspec').debug() end, "RSpec debug/run in terminal")
map.n("<leader>tS", function() require('rspec').run_suite() end, "RSpec run test suite")
map.n("<leader>t.", function() require('rspec').repeat_last_run() end, "RSpec repeat last run")

map:group "Rails navigation/Run"
map.n("<leader>rv", "<cmd>Eview<cr>", "Open controller action view file")
map.n("<leader>rc", "<cmd>Econtroller<cr>", "Open controller for this view file")
map.n("<leader>rd", "<cmd>w<cr><cmd>!dot -T png -O % | open %.png<cr>", "Run 'dot -T png' and open the PNG")
map.n("<leader>rr", "<cmd>RE<cr>", "Jump to Rails related file")
map.n("<leader>ra", "<cmd>AE<cr>", "Jump to Rails alternate file")

map:group "Diagnostics"
map.n("gl", vim.diagnostic.open_float, "Show line diagnostics")

map:group "Execute current file/line/selection with <Alt+x>"
map.n("<M-x>", function() return require("mp.utils").file_runner_cmd() end,
  { expr = true, desc = "Run the file via {filetype} language" })
map.n("<S-M-x>", function() return require("mp.utils").line_runner_cmd() end,
  { expr = true, desc = "Run current line via {filetype} language" })
map.v("<M-x>", function() return require("mp.utils").selection_runner_cmd() end,
  { expr = true, desc = "Run visual selection via {filetype} language" })

map:group "Miscellaneous"
function EscapedSelection()
  vim.cmd([[normal! gv"sy]])
  local selection = vim.fn.getreg("s")
  return string.gsub(vim.fn.escape(selection, "\\/.*$^~[]"), "\n", "\\n")
end

map.v("<C-r>", ":<C-u>%s/<C-r>=v:lua.EscapedSelection()<cr>//g<left><left>",
  "Replace selection in the buffer")

map.n("<Leader>sK", function()
  _G.__show_keymaps = true
  vim.cmd("source " .. vim.fn.stdpath("config") .. "/lua/mp/keymaps.lua")
  _G.__show_keymaps = false

  require("mp.which-keymap").show_keymaps()
end, "Show keymaps in right split window")
