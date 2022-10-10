--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]

require "mp.globals"

vim.cmd [[
set viminfo^=% " Remember info about open buffers on close

vnoremap <C-r> "hy:%s/<C-r>h//g<left><left>

" open up the definition in a new window
" nnoremap <silent> gv :vsplit<CR><cmd>lua vim.lsp.buf.definition()<CR>

cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" Enable custom syntax highlight
augroup ruby-rules
  autocmd!
  autocmd BufNewFile,BufRead *.rbw,*.gemspec,Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru setlocal filetype=ruby
  autocmd FileType ruby,eruby setlocal iskeyword+=!,?
augroup end

augroup remove-trailing-whitespaces
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e
augroup end

"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup end

"" Remember cursor position (You want this!)
augroup remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup end

autocmd FocusLost * :wa
]]

vim.opt.mouse = ""

vim.opt.colorcolumn = "100"
vim.opt.number = true
vim.opt.relativenumber = true -- Show line relative number

vim.opt.expandtab = true
vim.opt.smarttab = true       -- Use spaces instead of tabs / Be smart when using tabs ;)
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2       -- Set default tab size to 2

vim.opt.wrap = true           -- Wrap lines
vim.opt.breakindent = true    -- Indent wrapped lines
vim.opt.linebreak = true      -- Don't cut words on wrap
vim.opt.hlsearch = false      -- Don't highlight search results
vim.opt.wildmenu = true       -- Turn on visual autocompletion for command menu
vim.opt.incsearch = true      -- Select search match while typing
vim.opt.autoindent = true
vim.opt.smartindent = true    -- Auto indent / Smart indent
vim.opt.scrolloff = 8         -- Lines above/below cursor
vim.opt.sidescrolloff = 8

vim.opt.showcmd = true        -- Show (partial) command in the last line of the screen this also shows visual selection info
vim.opt.lazyredraw = true

vim.opt.updatetime = 300

vim.opt.backspace = "indent,eol,start" -- Fix backspace indent

vim.opt.termguicolors = true
vim.opt.background = "dark"

-- general
lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "onedark"
-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.insert_mode["jk"] = false
lvim.keys.insert_mode["kj"] = false
lvim.keys.insert_mode["jj"] = false

lvim.keys.normal_mode["<S-l>"] = "<cmd>BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = "<cmd>BufferLineCyclePrev<CR>"

lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["n"] = "nzzzv"
lvim.keys.normal_mode["N"] = "Nzzzv"

lvim.keys.normal_mode["<F5>"] = "<cmd>UndotreeToggle<cr>"
lvim.keys.normal_mode["<F4>"] = "<cmd>Twilight<cr>"
lvim.keys.normal_mode["<F8>"] = "<cmd>ZenMode<cr>"

lvim.keys.visual_mode["p"] = [["_dP]]
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = false
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
  -- for input mode
  i = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
    ["<C-n>"] = actions.cycle_history_next,
    ["<C-p>"] = actions.cycle_history_prev,
  },
  -- for normal mode
  n = {
    ["<C-j>"] = actions.move_selection_next,
    ["<C-k>"] = actions.move_selection_previous,
  },
}
lvim.builtin.telescope.defaults.file_ignore_patterns = {
  ".git/*",
  "node_modules/*",
  "tags",
}

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["<leader>x"] = { "<cmd>silent! w<cr><cmd>luafile %<cr>", "Execute lua file" }

lvim.builtin.which_key.mappings["x"] = { "<cmd>x<cr>", "Save & exit" }
lvim.builtin.which_key.mappings["h"] = nil
lvim.builtin.which_key.mappings.g.B = { "<cmd>Git blame<cr>", "Blame" }
lvim.builtin.which_key.mappings.g.l[2] = "Line blame"
lvim.builtin.which_key.mappings.g.o[2] = "Open changed files"

local function mp_finders(method_code, hint)
  return { "<cmd>lua require('mp.telescope.finders')." .. method_code .. "<cr>", hint }
end
lvim.builtin.which_key.mappings["f"] = {
  name = "Finders",
  f = mp_finders("files_no_preview()", "Files no preview"),
  w = mp_finders("word_under_cursor()", "Word under cursor"),
  p = { "<cmd>lua require('telescope.builtin').find_files({hidden=true})<cr>", "Files with preview" },
  g = { "<cmd>lua require('telescope.builtin').live_grep()<cr>", "Grep" },
  G = { "<cmd>lua require('telescope.builtin').live_grep({grep_open_files=true})<cr>", "Grep open files" },

  c = mp_finders("lsp_workspace_symbols('class')", "Classes"),
  m = mp_finders("lsp_workspace_symbols('module')", "Modules"),
  M = mp_finders("lsp_workspace_symbols('method')", "Methods"),

  C = mp_finders("my_config_files()", "My config files"),
}
lvim.builtin.which_key.mappings["t"] = {
  name = "Ctags/Onedark",
  R = {
    "<cmd>silent !ctags -R --languages=ruby --exclude=.git --exclude=log<cr>",
    "Ctags create Ruby"
  },
  n = { "<cmd>tag<cr>", "Jump to next tag" },
}

-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordspace Diagnostics" },
-- }

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true

lvim.builtin.terminal.active = true
lvim.builtin.terminal.open_mapping = [[<c-\>]]

lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.glyphs.git.staged = "✔"
lvim.builtin.nvimtree.setup.renderer.icons.glyphs.git.unstaged = "✘"
lvim.builtin.nvimtree.setup.renderer.icons.glyphs.git.untracked = "★"

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "ruby",
  "bash",
  "javascript",
  "json",
  "lua",
  "typescript",
  "tsx",
  "css",
  "yaml",
}
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.incremental_selection = {
  enable = true,
  keymaps = {
    init_selection = "<cr>",
    node_incremental = "<cr>",
    node_decremental = ",",
  },
}

lvim.builtin.lualine.options.theme = "onedark"

-- generic LSP settings
lvim.lsp.buffer_mappings.normal_mode["gr"] = {
  "<cmd>Telescope lsp_references<cr>", "Goto references"
}

lvim.lsp.diagnostics.float.focusable = true

-- ---@usage disable automatic installation of servers
-- lvim.lsp.automatic_servers_installation = false

-- ---configure a server manually. !!Requires `:LvimCacheReset` to take effect!!
-- ---see the full default list `:lua print(vim.inspect(lvim.lsp.automatic_configuration.skipped_servers))`
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "pyright" })
-- local opts = {} -- check the lspconfig documentation for a list of all possible options
-- require("lvim.lsp.manager").setup("pyright", opts)

-- ---remove a server from the skipped list, e.g. eslint, or emmet_ls. !!Requires `:LvimCacheReset` to take effect!!
-- ---`:LvimInfo` lists which server(s) are skiipped for the current filetype
-- vim.tbl_map(function(server)
--   return server ~= "emmet_ls"
-- end, lvim.lsp.automatic_configuration.skipped_servers)

-- -- you can set a custom on_attach function that will be used for all the language servers
-- -- See <https://github.com/neovim/nvim-lspconfig#keybindings-and-completion>
-- lvim.lsp.on_attach_callback = function(client, bufnr)
--   local function buf_set_option(...)
--     vim.api.nvim_buf_set_option(bufnr, ...)
--   end
--   --Enable completion triggered by <c-x><c-o>
--   buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
-- end

-- -- set a formatter, this will override the language server formatting capabilities (if it exists)
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "black", filetypes = { "python" } },
--   { command = "isort", filetypes = { "python" } },
--   {
--     -- each formatter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "prettier",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--print-with", "100" },
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "typescript", "typescriptreact" },
--   },
-- }

-- -- set additional linters
-- local linters = require "lvim.lsp.null-ls.linters"
-- linters.setup {
--   { command = "flake8", filetypes = { "python" } },
--   {
--     -- each linter accepts a list of options identical to https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md#Configuration
--     command = "shellcheck",
--     ---@usage arguments to pass to the formatter
--     -- these cannot contain whitespaces, options such as `--line-width 80` become either `{'--line-width', '80'}` or `{'--line-width=80'}`
--     extra_args = { "--severity", "warning" },
--   },
--   {
--     command = "codespell",
--     ---@usage specify which filetypes to enable. By default a providers will attach to all the filetypes it supports.
--     filetypes = { "javascript", "python" },
--   },
-- }

-- Additional Plugins
lvim.plugins = {
--     {
--       "folke/trouble.nvim",
--       cmd = "TroubleToggle",
--     },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gread", "Gwrite", "Gvdiffsplit" }
  },

  {
    "tpope/vim-projectionist",
    ft = { "ruby", "eruby" }
  },

  {
    "tpope/vim-dispatch",
    ft = { "ruby", "eruby" },
  },

  {
    "tpope/vim-bundler",
    ft = { "ruby", "eruby" },
  },

  {
    "tpope/vim-rake",
    ft = { "ruby" }
  },

  {
    "tpope/vim-rails",
    ft = { "ruby", "eruby" },
  },

  -- { "ecomba/vim-ruby-refactoring" },

  {
    "navarasu/onedark.nvim",
    config = function()
      local onedark = require("onedark")

      onedark.setup {
        style = "cool",
        toggle_style_key = "<leader>ts",
        code_style = {
          variables = "italic"
        },
        diagnostics = {
          background = false, -- use background color for virtual text
        },
      }

      onedark.load()
    end
  },

  {
    "RRethy/nvim-treesitter-endwise",
    after = "nvim-treesitter",
    ft = { "ruby", "lua", "bash" },
    config = function()
      require("nvim-treesitter.configs").setup { endwise = { enable = true } }
    end,
  },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    setup = function()
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_WindowLayout = 2
    end
  },
  -- { "danymat/neogen", },
  {
    "folke/twilight.nvim",
    cmd = "Twilight",
    config = function()
      require("twilight").setup {
        -- refer to the configuration https://github.com/folke/twilight.nvim#%EF%B8%8F-configuration
      }
    end
  },

  {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    config = function()
      require("zen-mode").setup {
        -- refer to the configuration https://github.com/folke/zen-mode.nvim#%EF%B8%8F-configuration
      }
    end
  }
}

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- lvim.autocommands.custom_groups = {
--   { "BufWinEnter", "*.lua", "setlocal ts=8 sw=8" },
-- }
