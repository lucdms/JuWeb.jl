# ============== #
#     Service	 #
# ============== #


include("../dao/TrackDAO.jl")

# bussiness interface application
type TrackService
	
	select::Function
	list::Function

	function TrackService()
	
		this = new()
		
		
		function list()
			return TrackDAO().list() #invoke dao
		end
		
		
		
		function select(id)
			return TrackDAO().select(id) #invoke dao
		end
	
	
	
		this.select=select
		this.list=list

		return this
	
	end

end