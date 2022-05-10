local opts = { noremap = true, silent = true }


local function setup_vim_diagnostic()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    underline = false,
    virtual_text = true,
    severity_sort = true,
    update_in_insert = true,
    signs = {
      active = signs,
    },
    float = {
      focusable = false,
      style = "minimal",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)
end

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local function set_keymap(...) vim.api.nvim_set_keymap('n', ...) end
set_keymap('<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
set_keymap('[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
set_keymap(']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
-- set_keymap('<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
setup_vim_diagnostic()


local function lsp_highlight_document(client)
  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        " autocmd CursorHold *.* :lua vim.lsp.diagnostic.show_line_diagnostics()
        " autocmd BufWritePre * lua vim.lsp.buf.formatting_sync(nil, 300)
      augroup END
    ]], false)
  -- else
  --   vim.api.nvim_exec([[
  --     autocmd!
  --     autocmd BufWritePre * Neoformat
  --     augroup END
  --   ]], false)
  end
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, 'n', ...) end

  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_set_keymap('<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- buf_set_keymap('<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_set_keymap('<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  -- Set keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
      buf_set_keymap('<space>tt', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  elseif client.resolved_capabilities.document_range_formatting then
      buf_set_keymap('<space>tt', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end

  lsp_highlight_document(client)
end


local lspconfig = require('lspconfig')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

local capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local lsp_servers = {
  -- Instalation:
  --   gem install solargraph
  solargraph = {},

  -- Instalation:
  --   gem install sorbet
  --   srb init
  -- sorbet = {
  --   cmd = { "srb", "tc", "--lsp", "--disable-watchman", "--enable-all-experimental-lsp-features" },
  -- },

  -- Instalation:
  --   npm install -g -f typescript typescript-language-server
  tsserver = {},
}

-- Setup declared LSP servers
for server, config in pairs(lsp_servers) do
  config.on_attach = on_attach
  config.capabilities = capabilities
  config.flags = {
    -- This will be the default in neovim 0.7+
    debounce_text_changes = 150,
  }

  lspconfig[server].setup(config)
end
