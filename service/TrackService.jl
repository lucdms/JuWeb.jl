# ============== #
#     Service	 #
# ============== #


include("../dao/TrackDAO.jl")

type TrackService
	
	select::Function
	list_all::Function

	function TrackService()
	
		#track_dao::TrackDAO #dao
		this = new()
		
		function list_all()
			println("Acessing TrackService! Bussiness interface application. list_all()")
			#services
			#return this.track_dao.get_list() #invoke dao
			return TrackDAO().list_all() #invoke dao
		end
		
		
		function select(id)
			println("Acessing TrackService! Bussiness interface application. select(id)")
			return TrackDAO().select(id) #invoke dao
		end
	
		this.select=select
		this.list_all=list_all

		return this
	
	end

end