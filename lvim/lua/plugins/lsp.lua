return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      servers = {
        solargraph = {
          mason = false, -- disable auto-installing with mason
        },
        ruby_lsp = {
          mason = false, -- disable auto-installing with mason
        },
      },
    },
  },
}
