-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local del = vim.keymap.del

-- INFO: Unbinding Lazy default keymaps

del("n", "<leader>wd") -- Delete Window
del("n", "<leader>wm") -- Enable Zoom Mode
del("n", "<leader>qq") -- Quite All
del({ "i", "x", "n", "s" }, "<C-s>") -- Save file

-- better up/down
del({ "n", "x" }, "j")
del({ "n", "x" }, "k")
del({ "n", "x" }, "<Up>")
del({ "n", "x" }, "<Down>")

-- quickfix/location lists
del({ "n" }, "<leader>xq")
del({ "n" }, "<leader>xl")

-- Trouble
del({ "n" }, "<leader>xx")
del({ "n" }, "<leader>xX")
del({ "n" }, "<leader>xL")
del({ "n" }, "<leader>xQ")

-- Terminal
del({ "n" }, "<leader>fT")
-- INFO: Loading my keymaps

require("mp.keymaps")
