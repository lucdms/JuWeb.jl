# =================== #
#   TrackController   # 
# =================== #

using HttpServer
using SQLite

#service layer
include(joinpath(SERVICE_PATH,"TrackService.jl"))

type TrackController
		
	track_service::TrackService #service
		
	#methods
	index::Function
	select::Function
	list_all::Function
	
	test_params::Function
	
	#construtor
	function TrackController()
		
		this = new()
		#this.track_service = TrackService()
		

		function index(req::Request,res::Response)
			println("Acessing TrackController! Interface with views. Called index()")			
			return Response(string(TrackService().list_all()))
		end
		
		
		function select(req::Request,res::Response)
			id_number = parse(Int, split(req.resource,'/')[3])
			println("Acessing TrackController! Interface with views. Called select()")			
			track = TrackService().select(id_number)
			#return json
			return Response(track.getJSON())
		end
		
		
		function list_all(req::Request,res::Response)
			println("Acessing TrackController! Interface with views. Called list_all()")			
			all = TrackService().list_all()
			println("opa")
			#println(all)
			#return json
			#println(JSON.parse(all))
			return Response(JSON.json(all))
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
			return string(params)
		end
				
		
		#set methods
		this.index = index		
		this.select = select
		this.list_all = list_all
		this.test_params = test_params
		
		
		println("criado TrackController")	

		
		return this
		
		
		
	end

end