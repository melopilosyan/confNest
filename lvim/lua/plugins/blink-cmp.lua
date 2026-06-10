return {
  {
    "saghen/blink.cmp",
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
