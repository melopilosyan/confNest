local float = require "plenary.window.float"

local M = {}

local command = { "bundle", "exec", "rspec", nil }

function M.run()
  command[4] = vim.fn.expand("%:.")

  float.percentage_range_window(0.9, 0.8, { winblend = 0 }, {
    -- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    topleft = "╭",
    topright = "╮",
    top = "─",
    left = "│",
    right = "│",
    botleft = "╰",
    botright = "╯",
    bot = "─",

    -- topleft = "╔",
    -- topright = "╗",
    -- top = "═",
    -- left = "║",
    -- right = "║",
    -- botleft = "╚",
    -- botright = "╝",
    -- bot = "═",
  })

  vim.fn.termopen(command)
end

return M
