require "mp.globals"

vim.cmd [[
set viminfo^=% " Remember info about open buffers on close

" Makes the dot(.) work in visual mode
vnoremap . :norm.<cr>

function! EscapedSelection()
  normal! gv"sy
  return substitute(escape(getreg("s"), '\/.*$^~[]'), "\n", '\\n', "g")
endfunction

" Substitute occurrences of selected text in the buffer
xnoremap <C-r> :<C-u>%s/<C-r>=EscapedSelection()<cr>//g<left><left>

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
  autocmd BufNewFile,BufRead *.rbw,*.gemspec,Gemfile,Rakefile,Capfile,Vagrantfile,Thorfile,config.ru setlocal filetype=ruby
  autocmd FileType ruby,eruby,slim setlocal iskeyword+=!,?
augroup end

augroup remove-trailing-whitespaces
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e
augroup end

"" Remember cursor position (You want this!)
augroup remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup end

autocmd FocusLost * :wa
]]

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  group = vim.api.nvim_create_augroup("set yaml filetype", {}),
  pattern = { "*.yml" },
  desc = "Rails.vim sets *.yml files type to eruby.yaml. Set it back to yaml",
  callback = function()
    vim.defer_fn(function() vim.cmd "set filetype=yaml" end, 100)
  end,
})

vim.opt.mouse = ""

vim.opt.colorcolumn = "100"
vim.opt.number = true
vim.opt.relativenumber = true -- Show line relative number
vim.opt.signcolumn = "yes"

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

vim.opt.spelllang = "en_gb"

--- Helper functions
local function with(tbl, callback) callback(tbl) end

local function bulk_change(tbl, keys, callback)
  for _, key in ipairs(keys) do callback(tbl[key]) end
end

local function mp_finders(method_code, hint)
  return { "<cmd>lua require('mp.telescope.finders')." .. method_code .. "<cr>", hint }
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

--- Normal mode mappings with <leader> prefix
with(lvim.builtin.which_key.mappings, function(lm)
  lm["<leader>x"] = { ":silent! w<cr><cmd>luafile %<cr>", "Execute lua file" }
  lm["/"] = nil

  lm.h = nil
  lm.d = nil
  lm.x = { "<cmd>x<cr>", "Save & exit" }

  lm.g.l[2] = "Line blame"
  lm.g.B = { "<cmd>Git blame<cr>", "Blame buffer" }
  lm.g.G = { "<cmd>Git<cr>", "Git fugitive" }
  lm.g.g = { "<cmd>Git commit<cr>", "Git commit" }
  lm.g.o = mp_finders("git_status()", "Open changed files")
  lm.g.l = { "<cmd>lua require 'gitsigns'.blame_line{full=true}<cr>", "Line blame" }
  lm.g.S = { "<cmd>lua require 'gitsigns'.stage_buffer()<cr>", "Stage Buffer" }
  lm.g.C = mp_finders("git_commits()", "Checkout commit")
  lm.g.c = mp_finders("git_commits{file = true}", "Checkout commit(for current file)")

  lm.f = {
    name = "Finders",
    f = mp_finders("files_no_preview()", "Files no preview"),
    w = mp_finders("word_under_cursor()", "Word under cursor"),
    W = mp_finders("word_under_cursor{grep_open_files = true}", "Word under cursor in open files"),
    p = { "<cmd>lua require('telescope.builtin').find_files({hidden=true})<cr>", "Files with preview" },
    t = mp_finders("live_grep()", "Text"),
    T = mp_finders("live_grep{grep_open_files = true}", "Text in open files"),

    c = mp_finders("lsp_workspace_symbols('class')", "Classes"),
    m = mp_finders("lsp_workspace_symbols('module')", "Modules"),
    M = mp_finders("lsp_workspace_symbols('method')", "Methods"),

    C = mp_finders("my_config_files()", "My config files"),
  }

  lm.t = {
    name = "Ctags/Tests/Toggle",
    R = {
      "<cmd>silent !ctags -R --languages=ruby --exclude=.git --exclude=log<cr>",
      "Ctags create Ruby"
    },
    n = { "<cmd>tag<cr>", "Jump to next tag" },
    I = { "<cmd>lua require('rspec.integrated').run_spec_file()<cr>", "RSpec run file" },
    i = {
      "<cmd>lua require('rspec.integrated').run_spec_file{only_current_example = true}<cr>",
      "RSpec run current example"
    },
    w = { "<cmd>lua require('mp.rspec.floating_window').run()<cr>", "RSpec run in window" },
    p = { "<cmd>TSPlaygroundToggle<cr>", "Treesitter playground toggle" },
    m = { "<cmd>MarkdownPreviewToggle<cr>", "Markdown preview toggle" },
    s = { "<cmd>set spell!<cr><cmd>set spell?<cr>", "Toggle spelling" },
    c = { function()
            vim.opt.number = not vim.opt.number:get()
            vim.opt.relativenumber = not vim.opt.relativenumber:get()
            vim.opt.signcolumn = vim.opt.signcolumn:get() == "yes" and "no" or "yes"
          end,
          "Toggle sign & number columns"
    },
  }
  lm.r = {
    name = "Rails navigation/Run",
    v = { "<cmd>Eview<cr>", "Open controller action view file" },
    c = { "<cmd>Econtroller<cr>", "Open controller for this view file" },
    d = { "<cmd>w<cr><cmd>!dot -T png -O % | open %.png<cr>", "Run 'dot -T png' and open the PNG" },
  }
end)

--- Visual mode mappings with <leader> prefix
with(lvim.builtin.which_key.vmappings, function(vm)
  vm.g = {
    name = "Git",
    r = { "<cmd>lua require('gitsigns').reset_hunk{vim.fn.line('.'), vim.fn.line('v')}<cr>", "Reset Hunk (linewise)" },
    s = { "<cmd>lua require('gitsigns').stage_hunk{vim.fn.line('.'), vim.fn.line('v')}<cr>", "Stage Hunk (linewise)" },
  }
  vm.f = {
    name = "Find",
    w = mp_finders("selection{word = true}", "Selection as word"),
    W = mp_finders("selection{word = true, grep_open_files = true}", "Selection as word in open files"),
    t = mp_finders("selection()", "Selection as text"),
    T = mp_finders("selection{grep_open_files = true}", "Selection as text in open files"),
  }
end)

with(lvim.builtin, function(bi)
  bi.alpha.active = true
  bi.alpha.mode = "dashboard"

  bi.lualine.options.theme = "onedark"
  bi.nvimtree.setup.view.side = "left"

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

  -- Better nerd font icons
  local folder = ""
  local folder_open = ""
  with(bi.nvimtree.setup.renderer.icons.glyphs, function(g)
    g.folder.default = folder
    g.folder.open = folder_open
    g.folder.symlink_open = folder_open
    g.git.staged = "✔"
    g.git.unstaged = "✘"
    g.git.untracked = ""
  end)
  bi.breadcrumbs.options.icons.Folder = folder .. " "

  --- Telescope settings
  with(bi.telescope, function(ts)
    local _, actions = pcall(require, "telescope.actions")

    ts.theme = nil
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
end)

--- LSP settings
with(lvim.lsp, function(lsp)
  lsp.installer.setup.automatic_installation = false
  lsp.buffer_mappings.normal_mode["gr"] = {
    "<cmd>Telescope lsp_references<cr>", "Goto references"
  }

  lsp.document_highlight = false
end)

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  group = vim.api.nvim_create_augroup("ruby-frozen", {}),
  pattern = { "*.rb", "*.rake" },
  desc = "Annotate Ruby files with `frozen_string_literal: true`",
  callback = function() vim.schedule(function ()
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
    if not first_line:find("frozen_string_literal:") then
      vim.api.nvim_buf_set_lines(0, 0, 1, false, { "# frozen_string_literal: true", "", first_line })
    end
  end) end,
})

vim.api.nvim_create_autocmd("FileType", {
  once = true,
  pattern = "slim",
  desc = "Register slim-lint as null-ls diagnostics entry",
  callback = function() vim.schedule(require("mp.null-ls.slim_lint")) end,
})

-- Additional Plugins
lvim.plugins = {
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gread", "Gwrite", "Gvdiffsplit" }
  },

  { "tpope/vim-surround", event = "VeryLazy" },

  { "melopilosyan/rspec-integrated.nvim", lazy = true },

  {
    "tpope/vim-projectionist",
    event = "VeryLazy",
    ft = { "ruby", "eruby" }
  },

  {
    "tpope/vim-rake",
    event = "VeryLazy",
    ft = { "ruby" }
  },

  {
    "tpope/vim-bundler",
    event = "VeryLazy",
    cond = function ()
      return vim.fn.filereadable("Gemfile") == 1
    end,
  },

  {
    "tpope/vim-rails",
    event = "VeryLazy",
    cond = function ()
      return vim.fn.filereadable("config/environment.rb") == 1
    end,
  },

  -- { "ecomba/vim-ruby-refactoring" },

  { "slim-template/vim-slim", ft = "slim" },

  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    config = function ()
      require('leap').add_default_mappings()
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle" },
    build = function() vim.fn["mkdp#util#install"]() end,
    config = function() vim.g.mkdp_filetypes = { "markdown" } end,
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
        lualine = {
          transparent = true, -- lualine center bar transparency
        },
      }

      onedark.load()
    end
  },

  {
    "RRethy/nvim-treesitter-endwise",
    ft = { "ruby", "lua", "bash" },
    config = function()
      require("nvim-treesitter.configs").setup { endwise = { enable = true } }
    end,
  },

  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle",
    config = function()
      require("nvim-treesitter.configs").setup {
        playground = {
          enable = true,
          disable = {},
          updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
          persist_queries = false, -- Whether the query persists across vim sessions
          keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
          },
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
      }
    end
  },

  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")
      notify.setup {
        stages = "fade",
      }

      vim.notify = notify
    end,
  },

  {
    "nvim-tree/nvim-web-devicons",
    config = function ()
      require'nvim-web-devicons'.setup {
        -- /home/meliq/.local/share/lunarvim/site/pack/lazy/opt/nvim-web-devicons/README.md
        override_by_extension = {
          ["vue"] = {
            icon = "󰡄",
            -- ~/.local/share/lunarvim/site/pack/lazy/opt/nvim-web-devicons/lua/nvim-web-devicons-light.lua
            -- color = "#466024",
            -- cterm_color = "22",
            -- ~/.local/share/lunarvim/site/pack/lazy/opt/nvim-web-devicons/lua/nvim-web-devicons.lua
            color = "#8dc149",
            cterm_color = "113",
            name = "Vue",
          }
        }
      }
    end
  },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    config = function()
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_SplitWidth = 25
      vim.g.undotree_HelpLine = 0
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
