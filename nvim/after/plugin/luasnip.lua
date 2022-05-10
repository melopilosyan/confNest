-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/after/plugin/luasnip.lua
-- https://github.com/L3MON4D3/LuaSnip/wiki/Cool-Snippets

vim.api.nvim_set_keymap(
  "n", "<leader><leader>s", "<cmd>so ~/.config/nvim/after/plugin/luasnip.lua<CR>",
  { noremap = true }
)

local ls = require "luasnip"
local types = require "luasnip.util.types"

ls.config.set_config {
  -- This tells LuaSnip to remember to keep around the last snippet.
  -- You can jump back into it even if you move outside of the selection
  history = true,

  -- This one is cool cause if you have dynamic snippets, it updates as you type!
  updateevents = "TextChanged,TextChangedI",

  -- Autosnippets:
  enable_autosnippets = true,

  -- Crazy highlights!!
  -- #vid3
  -- ext_opts = nil,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " <- Current Choice", "NonTest" } },
      },
    },
  },
}

-- create snippet
-- s(context, nodes, condition, ...)
local s = ls.snippet

-- This is the simplest node.
--  Creates a new text node. Places cursor after node by default.
--  t { "this will be inserted" }
--
--  Multiple lines are by passing a table of strings.
--  t { "line 1", "line 2" }
local t = ls.text_node

-- Insert Node
--  Creates a location for the cursor to jump to.
--      Possible options to jump to are 1 - N
--      If you use 0, that's the final place to jump to.
--
--  To create placeholder text, pass it as the second argument
--      i(2, "this is placeholder text")
local i = ls.insert_node

-- Function Node
--  Takes a function that returns text
local f = ls.function_node

-- This a choice snippet. You can move through with <c-l> (in my config)
--   c(1, { t {"hello"}, t {"world"}, }),
--
-- The first argument is the jump position
-- The second argument is a table of possible nodes.
--  Note, one thing that's nice is you don't have to include
--  the jump position for nodes that normally require one (can be nil)
local c = ls.choice_node

local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

ls.snippets = {
  all = {
    -- for all
    -- ls.parser.parse_snippet("exp", "-- I'm expended!!!"),
  },
  ruby = {
    -- for ruby
    ls.parser.parse_snippet("frozen", "# frozen_string_literal: true\n\n"),
    ls.parser.parse_snippet("#!", "#!/usr/bin/env ruby\n\n"),
    ls.parser.parse_snippet("pry", "\nrequire 'pry'; binding.pry\n"),

    s(".mapm", fmt(".map(&:{})", { t(1) })),
    s("do", fmt("do |{}|\n  {}\nend", { i(1), i(0) })),
    s(".ead", fmt(".each do |{}|\n  {}\nend", { i(1), i(0) })),
    s(
      ".eawid",
      fmt(".each_with_index do |{}, {}|\n  {}\nend",
          { i(1, "element"), i(2, "i"), i(0) })),
    s(
      ".eawid",
      fmt(".each_with_object({}) do |{}, {}|\n  {}\nend",
          { i(1, "obj"), i(2, "element"), i(3, "obj"), i(0) })),
    s(
      "case",
      fmt("case {}\nwhen {}\n  {}\nelse\n  {}\nend",
          { i(1), i(2, "condition"), i(3, "something"), i(0, "other") })),

    -- RSpec
    s("let", fmt("let(:{}).to {{ {} }}", { i(1, "variable"), i(0, "value") })),
    s("desc", fmt('describe "{}" do\n  {}\nend', { i(1), i(0) })),
    s("cont", fmt('context "{}" do\n  {}\nend', { i(1), i(0) })),
    s("it", fmt('it "{}" do\n  {}\nend', { i(1), i(0) })),
    s("exp", fmt("expect({}).to {}", { i(1), i(0, "be") })),
    s("experr", fmt("expect {{ {} }}.to raise_error({})", { i(1), i(0) })),
  },
  lua = {
    -- for ruby
  },
}

require("luasnip.loaders.from_snipmate").lazy_load()
