local conf = require "telescope.config".values
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"
local fmt, gsub = string.format, string.gsub

-- See `rg --type-list`
local TYPE_SHORTCUTS = {
  css = "css",
  js = "js",
  lock = "lock",
  lua = "lua",
  rb = "ruby",
  sh = "sh",
  yaml = "yaml",
}
local SHORTCUTS = {
  loc = "*/locales/**",
  rake = "*.rake",
  slim = "*.slim",
  spec = "*_spec.rb",
}
local GLOBS_DELIMITER = "  "

local function parameterize(glob)
  if TYPE_SHORTCUTS[glob] then return "--type", TYPE_SHORTCUTS[glob] end
  if SHORTCUTS[glob] then return "--glob", SHORTCUTS[glob] end

  if glob:sub(0, 1) == "!" then
    local sub = glob:sub(2, -1)
    if TYPE_SHORTCUTS[sub] then return "--type-not", TYPE_SHORTCUTS[sub] end
    if SHORTCUTS[sub] then return "--glob", "!" .. SHORTCUTS[sub] end
  end

  return "--glob", glob
end

local function ripgrep_cmd(pattern, globs)
  local cmd = {
    "rg", "--color=never", "--no-heading", "--column", "--smart-case",
    "--with-filename", "--line-number", "--regexp", pattern,
  }

  if globs and globs ~= "" then
    for _, glob in ipairs(vim.split(globs, "%s+", { trimempty = true })) do
      cmd[#cmd + 1], cmd[#cmd + 2] = parameterize(glob)
    end
  end

  return cmd
end

local function shape_pattern_and_globs(search, prompt, match_word)
  if not search then return unpack(vim.split(prompt, GLOBS_DELIMITER)) end

  -- Shell escape regexp specific characters. Then wrap with word boundaries if match_word is set.
  search = gsub(search, "[%(%)%[%]%{%}\\%?%-%+%*%^%$%.]", function(m) return "\\" .. m end)
  search = match_word and fmt("\\b{start-half}%s\\b{end-half}", search) or search

  if not prompt then return search end
  if prompt:sub(0, 2) == GLOBS_DELIMITER then
    return search, prompt:sub(3, -1)
  end

  local pattern, globs = unpack(vim.split(prompt, GLOBS_DELIMITER))
  return fmt("%s.*%s|%s.*%s", search, pattern, pattern, search), globs
end

--- Live Ripgrep Telescope picker
---@param opts table|nil: Telescope pickers general options plus the following
---@option search: string
---@option word_match: boolean
return function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
  local search = opts.search or (opts.word_match and vim.fn.expand("<cword>") or nil)

  pickers.new(opts, {
    debounce = 500,
    prompt_title = opts.prompt_title or (search and
      fmt("Ripgrep %s(%s) with globs", opts.word_match and "word " or "", search) or
      "Live ripgrep with globs"),
    previewer = conf.grep_previewer(opts),
    sorter = require("telescope.sorters").empty(),
    finder = finders.new_async_job {
      command_generator = function(prompt)
        if prompt == "" then prompt = nil end
        if not (search or prompt) then return end

        return ripgrep_cmd(shape_pattern_and_globs(search, prompt, opts.word_match))
      end,
      entry_maker = make_entry.gen_from_vimgrep(opts),
      cwd = opts.cwd,
    },
  }):find()
end
