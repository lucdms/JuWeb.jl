# =================== #
#   LoginController   # 
# =================== #

using HttpCommon

#service layer
include(joinpath(VIEW_PATH,"View.jl"))


type LoginController
			
	#methods
	index::Function
	login_page::Function
	login_action::Function
	test_params::Function

	
	
	#constructor
	function LoginController()
		
		this = new()
				
		function index(req::Request,res::Response)
			#rendering a view
			println("Rendering LoginView")
			home_view = View("login.html")
			res.data = home_view.render()
			#returning a view
			return res
		end
		
		
		function login_page(req::Request,res::Response)
			#rendering a view
			println("Rendering LoginView")
			post_view = View("login.html")
			println("Returning LoginView")
			res.data = post_view.render()
			#returning a view
			return res
		end
		

		function login_action(req::Request,res::Response)
			println("post_action()")
			res.status = 200
			res.data = convert(req.data) #converte array de bytes em ASCIIString
			res.headers = Dict("Server"          => "Julia/$VERSION",
							  "Content-Type"     => "text/plain; charset=utf-8",
							  "Date"             => Dates.format(now(Dates.UTC), Dates.RFC1123Format) )
			return res
		end
		
		
		function test_params(req::Request,res::Response)
			url = req.resource
			query_string_params = url[search(url, '?')+1 : end] #substring indice inicial, final
			println(query_string_params) 
			#params in Dict - post in url
			params::Dict{AbstractString,AbstractString}
			params = HttpCommon.parsequerystring(query_string_params) #cria Dict com os params separados. ParÂmetros que foram passados pela URL
			for (n, f) in enumerate(params)
				println(string(n," => ",f))
			end
			res.status = 200
			res.data = string(params)
			res.headers = Dict("Server"          => "Julia/$VERSION",
							  "Content-Type"     => "text/plain; charset=utf-8",
							  "Date"             => Dates.format(now(Dates.UTC), Dates.RFC1123Format) )
			return res
		end
		
		
		function convert(a::Array{UInt8,1})
			i = findfirst(a .== 0)
			if i == 0
				s = ASCIIString(a)
			else
				s = ASCIIString(a[1:i-1])
			end
			return s
		end
		
		
		#set methods
		this.index = index		
		this.login_page = login_page
		this.login_action = login_action
		this.test_params = test_params
		
		
		return this
		
	end

end
