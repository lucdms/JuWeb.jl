# =================== #
#   TrackController   # 
# =================== #

using HttpServer
using SQLite

#service layer
include(joinpath(SERVICE_PATH,"TrackService.jl"))


#TrackController! Interface with views and users.
type TrackController
	
	select::Function
	list::Function

	function TrackController()
		
		this = new()
		
		
		function select(req::Request,res::Response)
			id_number = parse(Int, split(req.resource,'/')[3])
			track = TrackService().select(id_number)
			res.data = JSON.json(track)
			res.headers = Dict( "Server"           => "Julia/$VERSION",
							  "Content-Type"     => "application/json; charset=utf-8",
							  "Date"             => Dates.format(now(Dates.UTC), Dates.RFC1123Format) )
			return res
		end
		
		
		function list(req::Request,res::Response)
			all = TrackService().list()
			res.data = JSON.json(all)
			res.headers = Dict( "Server"           => "Julia/$VERSION",
							  "Content-Type"     => "application/json; charset=utf-8",
							  "Date"             => Dates.format(now(Dates.UTC), Dates.RFC1123Format) )
			return res
		end
				
		
		
		#set methods
		this.select = select
		this.list = list

		
		
		return this
		
		
	end

end
