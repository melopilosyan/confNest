local icons = LazyVim.config.icons.kinds

local source_to_menu = {
  buffer = "BUFF",
  path = "PATH",
  luasnip = "SNPT",
  nvim_lsp = "LSP",
  lazydev = "LDEV",
}

local function truncate(str, max_width)
  return vim.fn.strdisplaywidth(str or "") > max_width and
    vim.fn.strcharpart(str, 0, max_width - 1) .. "…" or str
end

local function kind_formatter(entry, item)
  item.kind = (icons[item.kind] or "") .. item.kind
  item.menu = (source_to_menu[entry.source.name] or "") .. (item.menu or "")

  item.abbr = truncate(item.abbr, 40)
  item.menu = truncate(item.menu, 40)

  return item
end

return {
  {
    "hrsh7th/nvim-cmp",
    optional = true,
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      ---@type LuaSnip
      local luasnip = lazy_require("luasnip")

      local cmp = require("cmp")
      local mapping = cmp.mapping

      return vim.tbl_deep_extend("force", opts, {
        mapping = mapping.preset.insert({
          ["<C-j>"] = mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-k>"] = mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

          ["<C-f>"] = mapping.scroll_docs(4),
          ["<C-b>"] = mapping.scroll_docs(-4),

          ["<CR>"] = mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert }),
          ["<S-CR>"] = mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),

          ['<C-l>'] = mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          ['<C-c>'] = mapping(function()
            if luasnip.choice_active() then
              luasnip.change_choice(1)
            end
          end, { 'i', 's' }),

          -- ["<tab>"] = function(fallback)
          --   return LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }, fallback)()
          -- end,
        }),

        formatting = {
          format = kind_formatter,
        },

        completion = {
          keyword_length = 3,
          completeopt = "menu,menuone,noinsert",
        },

        experimental = {
          ghost_text = false,
        },
      })
    end,
    keys = {
      { "<tab>", false, mode = "s" },
      { "<s-tab>", false, mode = { "i", "s" } },
    },
  },

  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      keymap = {
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        -- Hides the completion menu
        ['<C-e>'] = { 'hide', 'fallback' },
        -- Reverts completion.list.selection.auto_insert and hides the completion menu.
        ["<C-a>"] = { "cancel", "fallback" },
        ['<C-y>'] = { 'select_and_accept', 'fallback' },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },
        ['<C-j>'] = { 'select_next', 'fallback_to_mappings' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' }, -- scroll backward
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' }, -- scroll forward

        ["<C-h>"] = { "snippet_backward", "fallback" },
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ['<Tab>'] = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

        ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
        -- ["<C->e"] = { "-- todo: choice_active and change_choice" },
      },
    },
  }
}
