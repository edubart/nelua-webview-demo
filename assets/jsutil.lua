-- Some utilities to bridge Lua <-> JavaScript objects.

local js = require 'js'

local jsutil = {}

-- Checks if a table is an array or a hash map.
local function is_array(t)
  return #t > 0 or not next(t)
end

-- Converts a Lua table to a JavaScript Object.
function jsutil.Object(t)
  local r = js.new(js.global.Object)
  for k,v in pairs(t) do
    assert(type(k) == 'string' or js.typeof(k) == 'symbol')
    if type(v) == 'table' then
      if is_array(v) then
        v = jsutil.Array(v)
      else
        v = jsutil.Object(v)
      end
    end
    r[k] = v
  end
  return r
end

-- Converts a Lua table to a JavaScript Array.
function jsutil.Array(t)
  local r = js.new(js.global.Array)
  for _,v in ipairs(t) do
    if type(v) == 'table' then
      if is_array(v) then
        v = jsutil.Array(v)
      else
        v = jsutil.Object(v)
      end
    end
    r:push(v)
  end
  return r
end

-- Converts a Lua table to a JavaScript value.
function jsutil.jsfy(v)
  if type(v) == 'table' then
    if is_array(v) then
      return jsutil.Array(v)
    else
      return jsutil.Object(v)
    end
  end
  return v
end

-- Marks package as loaded.
package.loaded.jsutil = jsutil

return jsutil
