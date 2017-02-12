# =============== #
#   JuWebServer   #
# =============== #

#using HttpServer

type JuWebServer
		
	application
	host::AbstractString
	port::Int
	
	run::Function
	
	
	function JuWebServer(application, host="localhost",port=8000)
		
		this = new()
		
		this.application = application
		this.host = host
		this.port = port
		
		
		function run()
		  #http = HttpHandler((req, res)-> handler(b,req,res))
		  http = HttpHandler((req, res)-> application.handler_request(req,res)) #seta a application handler
		  http.events["error"]  = (client, error) -> println(error)
		  http.events["listen"] = (port)          -> println("Listening on $port...")
		  if host=="localhost"
			host="127.0.0.1"
		  end
		  try
			IPv4(host)
			#@async run(server, host=IPv4(host), port=port)
			HttpServer.run(Server(http), host=IPv4(host), port=port)
		  catch
			"only IPv4 addresses"
		  end
		end
		
		
		this.run = run
	
		
		return this
	
	end
		
end

