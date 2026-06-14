-- Handlers ruby-lsp's openFile code lens commands.
-- `command.arguments` can be:
--    "file:///full/path/to/file.rb#L123"
--    "file:///full/path/to/file.rb"
vim.lsp.commands["rubyLsp.openFile"] = function(command)
  local parts = vim.split(command.arguments[1][1] --[[@as string]], "#L")
  local prefix = "file://" .. vim.uv.cwd()
  local path = string.sub(parts[1], #prefix + 2)
  local line_num = tonumber(parts[2]) or 1

  vim.cmd.edit(vim.fn.fnameescape(path))
  vim.api.nvim_win_set_cursor(0, { line_num, 0 })
end

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

          -- https://shopify.github.io/ruby-lsp/editors.html#lazyvim-lsp
          cmd = { vim.fn.expand(string.format("~/.rvm/rubies/%s/bin/ruby-lsp", vim.env.RUBY_VERSION)) },
        },
        rubocop = {
          mason = false, -- disable auto-installing with mason
        },
      },
    },
  },
}
