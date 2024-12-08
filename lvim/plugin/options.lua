local o = vim.opt

-- Disable 🐭
o.mouse = ""

o.number = true
o.relativenumber = true

o.cursorline = true
o.signcolumn = "yes"
o.colorcolumn = "100"

o.expandtab = true
o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2

o.scrolloff = 8
o.sidescrolloff = 8

o.linebreak = true
o.breakindent = true

o.autoindent = true
o.smartindent = true

o.hlsearch = false

o.termguicolors = true

o.spelllang = "en_gb"

o.inccommand = "split"

-- Show the status line always and ONLY for the last window
o.laststatus = 3

o.showcmd = true

-- Disable merging nvim clipboard with OS
o.clipboard = ""

o.swapfile = false
o.undofile = true
o.undodir = vim.fn.stdpath("cache") .. "/undo"

-- Remember open buffers
o.viminfo:prepend("%")
