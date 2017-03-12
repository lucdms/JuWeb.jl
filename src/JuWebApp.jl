# ============ #
#   JuWebApp   #
# ============ #

export JuWebApp

type JuWebApp

	handler_request::Function
	
	function JuWebApp()
		
		this = new()
		
		#handle requests from URL
		function handler_request(req::Request, res::Response)
			println(string("JuWebApp (Handler) received a requisition from URL: ",req.resource))
			println("HEADERS: ")
			for (n, f) in enumerate(req.headers)
				println(string("    ",f[1]," => ",f[2]))
			end
			println(string("METHOD: ",req.method))				
			println(string("BODY DATA in Uint8 (Bytes): ",req.data))
			#try to catch required url's callback, returning your response
			callback_method = router.callback(req, res) #retorna a Function da "rota" buscada
			return callback_method	
		end
			
		
		this.handler_request = handler_request
		
		
		return this
		
		
	end
		
end

