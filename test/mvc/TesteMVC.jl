module TesteMVC

  export model,
         controller,
         routes,
         run

  global _models = Dict(),
         _controllers = Dict(),
         _routes = Dict()

  function model(methods, name::String)
    println("Adding model $name")
    _models[name] = methods
  end

  module Controller
    function render(thing)
      println(thing)
    end
  end

  function controller(actions, name::String)
    println("Adding controller $name, $actions")
    _controllers[name] = actions
  end

  function routes(TesteMVC_routes)
    # Flip routes around
    for route in TesteMVC_routes
      controller, path = route
      _routes[path] = controller
    end
  end

  function run()
    # Main loop of web TesteMVC
    # For now just to test, lets just call posts#index
    run_route("/")
  end

  # this is totally wrong
  function run_route(path::String)
	println("exec(_routes[path])")
	exec(_routes[path])
  end
	
end

# using TesteMVC

### Routes
TesteMVC.routes((
  # "post"           => [:create, :edit, :update, :destroy],
  # "post"           => :resource,
  "main#index"     => "/",
  "posts#index"    => "/posts"
))

### Models
TesteMVC.model("Post") do
  # something
  function title()
    "Title of post"
  end
end

### Controllers
TesteMVC.controller("posts") do
  using TesteMVC.Controller

  function index()
    render(Post.title())
  end
end

TesteMVC.run()