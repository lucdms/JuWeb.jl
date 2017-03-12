# =============== #
#   JuWebServer   #
# =============== #

export JuWebServer

type JuWebServer
		
	application
	host::AbstractString
	port::Int
	
	run::Function
	info::Function
	
	
	function JuWebServer(application, host="localhost",port=8000)
		
		this = new()
		
		this.application = application
		this.host = host
		this.port = port
		
		function run()
		  http = HttpHandler((req, res)-> application.handler_request(req,res)) #seta a application handler
		  http.events["error"]  = (client, error) -> println(error)
		  http.events["listen"] = (port)          -> print_with_color(:yellow,"Listening on $port...\n")
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
		
		
		
		function info()
			return string(this.application, " ", this.host, " ", this.port)
		end
		
				
		this.run = run
		this.info = info
		
		
		return this
	
	end
		
end

