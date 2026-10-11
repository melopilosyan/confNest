-- Avoids blinking
vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })

vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/lazy/kitty-scrollback.nvim")
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/lazy/telescope.nvim")
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/lazy/plenary.nvim")
vim.opt.runtimepath:append(vim.fn.stdpath("data") .. "/lazy/flash.nvim")

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- | Default Mapping | Description       | Mode  |
-- | --------------- | ----------------- | ----- |
-- | <C-CR>          | execute command   | n,v,i |
-- | <S-CR>          | paste command     | n,v,i |
-- | g?              | toggle footer     | n     |
-- | q               | close or quit all | n     |
-- | <C-c>           | quit all          | n,i,t |
-- | <Leader>y       | Maps to "+y       | n,v   |
-- | <Leader>Y       | Maps to "+Y       | v     |
-- | <Leader>Y       | Maps to "+y$      | n     |
-- | <Leader>yy      | Maps to "+yy      | n     |

vim.keymap.set("n", "<C-f>", function() require("telescope.builtin").current_buffer_fuzzy_find() end)
vim.keymap.set("n", "<C-e>", "10<C-e>", { desc = "Scroll up 10 lines" })
vim.keymap.set("n", "<C-y>", "10<C-y>", { desc = "Scroll down 10 lines" })
vim.keymap.set("n", "s", function() require("flash").jump() end)

local function after_launch()
  local o = vim.opt
  o.mouse = ""
  o.relativenumber = true

  require("flash").setup({
    modes = {
      char = {
        enabled = false,
      },
    },
  })
end

require("kitty-scrollback").setup({
  {
    callbacks = {
      after_launch = after_launch,
    },
    visual_selection_highlight_mode = "reverse",
  },
})
