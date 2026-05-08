-- Save and reload sessions per working directory
--
-- Create a session file for the current working directory by <Ctrl+s>.
-- It will then be auto-loaded the next time Neovim is opened in that
-- directory without parameters and auto-saved on close.
-- Reload previously saved session manually with <Ctrl+Shift+s>.

local function file_path()
  local dir = vim.fn.stdpath("cache") .. "/sessions/"
  local file_name = string.gsub(vim.fn.getcwd(), "/", "%%")
  vim.fn.mkdir(dir, "p")

  return dir .. file_name
end

local function save()
  vim.v.this_session = file_path()
  vim.cmd("mksession! " .. vim.fn.fnameescape(vim.v.this_session))
end

local function load()
  local path = file_path()
  if vim.fn.filereadable(path) == 0 then return end

  vim.cmd("source " .. vim.fn.fnameescape(path))
end

vim.keymap.set("n", "<C-s>", save)
vim.keymap.set("n", "<C-S-s>", load)

local group = vim.api.nvim_create_augroup('sessions', {})

vim.api.nvim_create_autocmd("VimLeave", {
  group = group,
  desc = "Autosave current session if any",
  callback = function()
    if vim.v.this_session ~= "" then save() end
  end,
})

if vim.fn.argc() == 0 then
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    group = group,
    desc = "Autoload session for current working directory if present",
    callback = function()
      vim.defer_fn(load, 10)
    end,
  })
end
