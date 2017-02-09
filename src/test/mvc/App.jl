module App

type troute
  method::ASCIIString
  url::ASCIIString
  func::Function
end 
		

		
  export model,
         controller,
         add_route,
         run,
		 @RequestMapping
		 
		 

  global _models = Dict(),
         _controllers = Dict(),
         _routes = Dict()
	
	
macro RequestMapping(exp1,exp2,exp3)
  quote
    push!(_routes,$exp2 => get_troute($exp1,$exp2,$exp3))
    #nothing
  end
end
		 
function get_troute(method::ASCIIString,url::ASCIIString,code::Function)
    troute(method,url,code)
end
		 
  function model(methods, name::ASCIIString)
    println("Adding model $name")
    _models[name] = methods
  end

  module Controller
    function render(thing)
      println(thing)
    end
  end

  function controller(actions, name::ASCIIString)
    println("Adding controller $name, $actions")
    _controllers[name] = actions
  end

  
  
  
  
  function add_route(method::ASCIIString,url::ASCIIString,func::Function)
    # Flip routes around
	println(string("adicionando route em _routes (method=",method,", url=",url,", function=",func))
	push!(_routes, url => get_troute(method,url,func))
  end
  
  
  function run()
    # Main loop of web app
    # For now just to test, lets just call posts#index
    run_route("/lucdms")
  end

  # this is totally wrong
  function run_route(path::ASCIIString)
    #try
	  _routes[path].func()
	  println(_routes[path])
	#catch
    #  "err exception"
	#end
  
  end
	
end

using App

### Routes
#App.add_route("GET", "/", function index(q,r)
#  println(string("service GET barra (", q, ",", r,")"))
#end)

#@route "GET" "/lucdms" begin
#  "I did something!"
#end

@RequestMapping "GET" "/lucdms" function f()
  println("funcao eita") 
end

#App.add_route("GET", "/lucdms", function f()
#  println("funcao eita") 
#end)

#App.get("/data", (q,r)->(begin
#  println("data")
#end))

#App.routes((
#  "post"           => [:create, :edit, :update, :destroy],
#  "post"           => :resource,
#  "main#index"     => "/",
#  "posts#index"    => "/posts"
#))

### Models
App.model("Post") do
  # something
  function title()
    "Title of post"
  end
end

### Controllers
App.controller("posts") do
  using App.Controller

  function index()
    render(Post.title())
  end
end


App.run()