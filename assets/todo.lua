local js = require 'js'
local jsutil = require 'jsutil'
local new, J = js.new, jsutil.jsfy
local Vue = js.global.Vue

local function invoke(t)
  local msg = js.global.JSON:stringify(J(t))
  js.global.window.external:invoke(msg)
end

local app = {el = "#app",
  data = {
    todos = {
      {id=1, text='Learn Vue'},
      {id=2, text='Learn Lua'},
      {id=3, text='Build something awesome!'},
    },
    text = "",
  },
  methods = {}
}

-- Pushes a new item in the todo list.
local function add_todo(id, text)
  app.todos:push(J{id=id, text=text})
  app.text = ""
  invoke{type='add', todo={id=id, text=text}}
end

-- Called when the application is ready.
function app.ready()
  -- Add some TODOs
  add_todo(1, 'Learn Vue')
  add_todo(2, 'Learn Fengari')
end

-- Called when user click 'Add' button.
function app.methods.add_clicked()
  local id, text = #app.todos+1, app.text
  add_todo(id, text)
end

-- Called when user check/unused an item.
function app.methods.item_changed(_, todo)
  invoke{type='check', id=todo.id}
end

app = new(Vue, J(app))
