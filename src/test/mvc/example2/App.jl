POST="POST"
PUT="PUT"
DELETE="DELETE"
GET="GET"

	macro RequestMapping(method,path,func)
	  quote
		push!(b,pag($method,$path,(q,r)->$func))
	  end
	end

module App
    
  #export model,
  #       controller,
  #       routes,
  #       run

  global _models = Dict(),
         _controllers = Dict(),
         _routes = Dict()

  function model(methods, name::AbstractString)
    println("Adding model $name")
    _models[name] = methods
  end

  module Controller
    function render(thing)
      println(thing)
    end
  end

  function controller(actions, name::AbstractString)
    println("Adding controller $name, $actions")
    _controllers[name] = actions
  end

  function routes(app_routes)
    # Flip routes around
    for route in app_routes
      controller, path = route
      _routes[path] = controller
    end
  end

  function run()
    # Main loop of web app
    # For now just to test, lets just call posts#index
    run_route("/")
  end

  # this is totally wrong
  function run_route(path::AbstractString)
	#println()
	_routes[path]
  end
	
end

include("controller.jl")
include("routes.jl")
include("model.jl")

#using App
App.run()