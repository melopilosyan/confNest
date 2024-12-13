P = function(v)
  print(vim.inspect(v))
  return v
end

RELOAD = function(...)
  return require("plenary.reload").reload_module(...)
end

R = function(name)
  RELOAD(name)
  return require(name)
end

-- Fake LuaLS that this is a standard `require` function for module name autocompletion
-- https://github.com/LuaLS/lua-language-server/discussions/836#discussioncomment-9739336
LazyModule = require

--- Delays loading of a module until a function is called
---
---```lua
---   local utils = LazyModule("mp.utils")
---   local func1 = utils.func1
---   local func2 = utils.func2
---   print(func1()) -- mp.utils is loaded here
---```
---@param path string Module path: `a.b`
function LazyModule(path)
  return setmetatable({}, {
    __index = function(_, fun)
      return function(...)
        return require(path)[fun](...)
      end
    end
  })
end
