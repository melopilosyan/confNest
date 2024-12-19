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
local map = setmetatable({ opts = { noremap = true, silent = true } }, {
  __index = function(self, mode)
    self[mode] = function(lhs, rhs, opts)
      if opts then
        opts = type(opts) == "string" and { desc = opts } or opts
        opts.noremap = true
      end
      set(mode, lhs, rhs, opts or self.opts)
    end
    return self[mode]
  end,
})

-- Buffer navigation
map.n("L", "<cmd>BufferLineCycleNext<cr>")
map.n("H", "<cmd>BufferLineCyclePrev<cr>")

-- Window navigation
map.n("<C-l>", "<C-w>l", "Move to the left window")
map.n("<C-h>", "<C-w>h", "Move to the right window")
map.n("<C-k>", "<C-w>k", "Move to the top window")
map.n("<C-j>", "<C-w>j", "Move to the bottom window")

-- Tab navigation
map.n("<M-l>", "gt", "Move to the next tab page")
map.n("<M-h>", "gT", "Move to the previous tab page")

-- Terminal window navigation
map.t("<C-l>", "<C-\\><C-N><C-w>l", "Move to the left window")
map.t("<C-h>", "<C-\\><C-N><C-w>h", "Move to the right window")
map.t("<C-k>", "<C-\\><C-N><C-w>k", "Move to the top window")
map.t("<C-j>", "<C-\\><C-N><C-w>j", "Move to the bottom window")

map.t("<Esc>", "<C-\\><C-N>", "Esc in terminal window properly")

-- Window resizing
map.n("<M-w>", "<C-w>3+", "Make the window taller")
map.n("<M-s>", "<C-w>3-", "Make the window shorter")
map.n("<M-,>", "<C-w>3<", "Make the window narrower")
map.n("<M-.>", "<C-w>3>", "Make the window wider")

-- Move the current line/block
map.i("<M-k>", "<Esc>:m .-2<cr>==gi", "Move the line up")
map.i("<M-j>", "<Esc>:m .+1<cr>==gi", "Move the line down")
map.n("<M-k>", "<cmd>m .-2<cr>==", "Move the line up")
map.n("<M-j>", "<cmd>m .+1<cr>==", "Move the line down")
map.v("<M-k>", ":m '<-2<cr>gv-gv", "Move the line/block up")
map.v("<M-j>", ":m '>+1<cr>gv-gv", "Move the line/block down")

-- Move through and toggle the quickfix list
map.n("]q", "<cmd>cnext<cr>")
map.n("[q", "<cmd>cprev<cr>")
map.n("<C-q>", function()
  local wininfo = vim.fn.getwininfo(vim.fn.win_getid())
  vim.cmd(wininfo[#wininfo].quickfix == 1 and "cclose" or "copen")
end, "Toggle quickfix window per tab page")

-- Center(zz) and expand folds(zv) of a search match
map.n("n", "nzzzv")
map.n("N", "Nzzzv")

-- Toggle plugins
map.n("\\", "<cmd>NvimTreeToggle<cr>")
map.n("<F5>", "<cmd>UndotreeToggle<cr>")
map.n("<F4>", "<cmd>Twilight<cr>")
map.n("<F8>", "<cmd>ZenMode<cr>")

-- Stay in visual mode during indentation
map.v("<", "<gv")
map.v(">", ">gv")

-- Don't copy the selection on paste
map.v("p", [["_dP]])

---@module "mp.utils"
local utils = LazyModule("mp.utils")

-- Execute current file/line/selection with <Alt+x>
map.n("<M-x>", utils.file_runner_cmd,
  { expr = true, desc = "Run the file via {filetype} language" })
map.n("<S-M-x>", utils.line_runner_cmd,
  { expr = true, desc = "Run current line via {filetype} language" })
map.v("<M-x>", utils.selection_runner_cmd,
  { expr = true, desc = "Run visual selection via {filetype} language" })

function EscapedSelection()
  vim.cmd([[normal! gv"sy]])
  local selection = vim.fn.getreg("s")
  return string.gsub(vim.fn.escape(selection, "\\/.*$^~[]"), "\n", "\\n")
end

map.v("<C-r>", ":<C-u>%s/<C-r>=v:lua.EscapedSelection()<cr>//g<left><left>",
  "Replace selection in the buffer")
