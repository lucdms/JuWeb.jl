# ============ #
#   JuWebApp   #
# ============ #

#using HttpServer


type JuWebApp

	handler_request::Function
	
	function JuWebApp()
		
		this = new()
		
		#handle request (recebimento das requisições via URL)
		function handler_request(req::Request, res::Response)
			println(string("#I'm in JuWebApp.jl! The handle request recebeu a requisição via URL: ",req.resource))
			println(string("HEADERS: ",req.headers))
			println(string("METHOD: ",req.method))				
			println(string("DATA in Uint8 (Bytes): ",req.data))
			println(string("DATA in String converted from Uint8 Bytes: ",convert(req.data)))
			#println(parsequerystring(req.resource))
			#tentativa de chamar o callback da URL invokada, retorna a Response desejada
			route_method = router.get_method(req, res) #retorna a Function da "rota" buscada
			return route_method	
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
		this.handler_request = handler_request
		
		
		return this
		
		
	end
		
end

