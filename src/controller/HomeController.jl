# =================== #
#   TrackController   # 
# =================== #

using SQLite
using HttpCommon

#service layer
include(joinpath(SERVICE_PATH,"TrackService.jl"))
include(joinpath(VIEW_PATH,"View.jl"))


type HomeController
			
	#methods
	index::Function
	post_example::Function
	post_action::Function
	
	#construtor
	function HomeController()
		
		this = new()
		
		println("criado HomeController")	
		
		function index(req::Request,res::Response)
			println("Acessing HomeController! Interface with views. Called index()")
			#rendering a view
			println("Rendering HomeView")
			home_view = View("index-angular.html")
			res.data = home_view.render()
			println("Returning HomeView")
			#returning a view
			return res
		end
		
		
		function post_example(req::Request,res::Response)
			println("Acessing HomeController! Interface with views. Called post_example()")
			#rendering a view
			println("Rendering HomeView POST_EXAMPLE")
			post_view = View("post_example.html")
			println("Returning HomeView POST_EXAMPLE")
			res.data = post_view.render()
			#returning a view
			return res
		end
		
		
		#TODO melhorar este método para classe UTILS
		function convert(a::Array{UInt8,1})
			i = findfirst(a .== 0)
			if i == 0
				s = ASCIIString(a)
			else
				s = ASCIIString(a[1:i-1])
			end
			return s
		end
		
		
		function post_action(req::Request,res::Response)
			println("post_action()")
			res.status = 200
			res.data = convert(req.data) #converte array de bytes em ASCIIString
			return res
		end
		
		
		#set methods
		this.index = index		
		this.post_example = post_example
		this.post_action = post_action
		
		
		return this
		
	end

end