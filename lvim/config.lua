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

vim.opt.updatetime = 100

vim.opt.backspace = "indent,eol,start" -- Fix backspace indent

vim.opt.termguicolors = true
vim.opt.background = "dark"

--- Helper functions
local function with(tbl, callback) callback(tbl) end

local function bulk_change(tbl, keys, callback)
  for _, key in ipairs(keys) do callback(tbl[key]) end
end

--- Lvim
lvim.leader = "space"

lvim.log.level = "warn"
lvim.format_on_save = false
lvim.colorscheme = "onedark"

--- Inseart mode mappings
with(lvim.keys.insert_mode, function(im)
  im["jk"] = false
  im["kj"] = false
  im["jj"] = false
end)

--- Normal mode mappings
with(lvim.keys.normal_mode, function(nm)
  nm["<S-l>"] = "<cmd>BufferLineCycleNext<CR>"
  nm["<S-h>"] = "<cmd>BufferLineCyclePrev<CR>"

  nm["<C-s>"] = ":w<cr>"
  nm["n"] = "nzzzv"
  nm["N"] = "Nzzzv"

  nm["<F5>"] = "<cmd>UndotreeToggle<cr>"
  nm["<F4>"] = "<cmd>Twilight<cr>"
  nm["<F8>"] = "<cmd>ZenMode<cr>"
end)

--- Visual mode mappings
with(lvim.keys.visual_mode, function(vm)
  vm["p"] = [["_dP]]
end)

--- Mappings with <leader> prefix
with(lvim.builtin.which_key.mappings, function(lm)
  lm["<leader>x"] = { ":silent! w<cr><cmd>luafile %<cr>", "Execute lua file" }
  lm["/"] = nil

  lm.h = nil
  lm.x = { "<cmd>x<cr>", "Save & exit" }
  lm.g.B = { "<cmd>Git blame<cr>", "Blame" }
  lm.g.l[2] = "Line blame"
  lm.g.o[2] = "Open changed files"

  local function mp_finders(method_code, hint)
    return { "<cmd>lua require('mp.telescope.finders')." .. method_code .. "<cr>", hint }
  end

  lm.f = {
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

  lm.t = {
    name = "Ctags/Tests",
    R = {
      "<cmd>silent !ctags -R --languages=ruby --exclude=.git --exclude=log<cr>",
      "Ctags create Ruby"
    },
    n = { "<cmd>tag<cr>", "Jump to next tag" },
    i = { "<cmd>lua require('rspec.integrated').run_spec_file()<cr>", "RSpec run integrated" },
    w = { "<cmd>lua require('mp.rspec.floating_window').run()<cr>", "RSpec run in window" },
  }
end)

with(lvim.builtin, function(bi)
  bi.alpha.active = true
  bi.alpha.mode = "dashboard"

  bi.lualine.options.theme = "onedark"

  --- Deactivate these plugins
  bulk_change(bi, {
    "lir",
    "dap",
    "theme",
    "terminal",
    "autopairs",
    "illuminate",
    "breadcrumbs",
    "indentlines",
  }, function(plugin) plugin.active = false end)

  --- Telescope settings
  with(bi.telescope, function(ts)
    local _, actions = pcall(require, "telescope.actions")

    ts.defaults.mappings = {
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

    ts.defaults.file_ignore_patterns = {
      ".git/*",
      "node_modules/*",
      "tags",
    }

    -- Remove the default settings of { theme = "dropdown" } from these pickers
    bulk_change(ts.pickers, {
      "live_grep",
      "grep_string",
      "lsp_references",
    }, function(picker) picker.theme = nil end)
  end)

  --- Treesitter settings
  with(bi.treesitter, function(ts)
    ts.ensure_installed = { "ruby", "lua", "bash", "javascript", "json", "css", "yaml" }

    ts.incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<cr>",
        node_incremental = "<cr>",
        node_decremental = ",",
      },
    }
  end)

  --- NvimTree settings
  with(bi.nvimtree.setup, function(setup)
    setup.view.side = "left"

    with(setup.renderer.icons.glyphs.git, function(git_glyphs)
      git_glyphs.staged = "✔"
      git_glyphs.unstaged = "✘"
      git_glyphs.untracked = "★"
    end)
  end)
end)

--- LSP settings
with(lvim.lsp, function(lsp)
  lsp.buffer_mappings.normal_mode["gr"] = {
    "<cmd>Telescope lsp_references<cr>", "Goto references"
  }

  lsp.document_highlight = false
  lsp.diagnostics.float.focusable = true
end)

-- Additional Plugins
lvim.plugins = {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gread", "Gwrite", "Gvdiffsplit" }
  },

  { "melopilosyan/rspec-integrated.nvim" },

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
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    cmd = { "MarkdownPreview" },
    run = function() vim.fn["mkdp#util#install"]() end,
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },

  {
    "navarasu/onedark.nvim",
    config = function()
      local onedark = require("onedark")

      onedark.setup {
        style = "cool",
        toggle_style_key = false,
        code_style = {
          variables = "italic"
        },
        diagnostics = {
          background = false,
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
    "rcarriga/nvim-notify",
    config = function()
      local notify = require("notify")
      notify.setup {
        stages = "fade",
      }

      vim.notify = notify
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
