# ============== #
#     DAO		 #
# ============== #

using SQLite

include("../config/constants.jl") #constants

include("AbstractDAO.jl")
include(joinpath(REPOSITORY_PATH,"JuWebRepository.jl"))
include(joinpath(MODEL_PATH,"TrackModel.jl"))


type TrackDAO <: AbstractDAO

	create::Function
	select::Function
	update::Function
	delete::Function
	list::Function
	count::Function
	
	function TrackDAO()
	
		this = new()
		
		function create()
			println("create()")
		end
		
		function select(id)
			println("TrackDAO.select(id)")
			
			bd = JuWebRepository.get_db()
			sql = string("SELECT * FROM tracks where TrackId=",id)
			query = SQLite.query(bd, sql)
		
			track = TrackModel()
			
			try
				track.track_id = string(query[1,1].value)
			catch
				track.track_id = nothing
			end
			
			try
				track.name = string(query[1,2].value)
			catch
				track.name = nothing
			end
			
			try
				track.album_id = string(query[1,3].value)
			catch
				track.album_id = nothing
			end
			
			try
				track.media_type_id = string(query[1,4].value)
			catch
				track.media_type_id = nothing
			end
			
			try
				track.genre_id = string(query[1,5].value)
			catch
				track.genre_id = nothing
			end
			
			try
				track.composer = string(query[1,6].value)
			catch
				track.composer = nothing
			end
			
			return track
			
		end
		
		function update(t::TrackModel)
			println("TODO: update()")
		end
		
		function delete(id)
			println("TODO: delete()")
		end
		
		function list()
			println("Acessing TrackDAO! Interface with databases / repositories.  list()")
			
			bd = JuWebRepository.get_db()
			sql = "SELECT * FROM tracks"
			query = SQLite.query(bd, sql)
			
			#list
			list = TrackModel[]
			
			println("list")
			
			for i = 1:size(query)[1]
		   
			    track = TrackModel()
	
				try
					track.track_id = string(query[i,1].value)
				catch
					track.track_id = nothing
				end
				
				try
					track.name = string(query[i,2].value)
				catch
					track.name = nothing
				end
				
				try
					track.album_id = string(query[i,3].value)
				catch
					track.album_id = nothing
				end
				
				try
					track.media_type_id = string(query[i,4].value)
				catch
					track.media_type_id = nothing
				end
				
				try
					track.genre_id = string(query[i,5].value)
				catch
					track.genre_id = nothing
				end
				
				try
					track.composer = string(query[i,6].value)
				catch
					track.composer = nothing
				end
				
				#list[i]=track
				push!(list,track)
				
			   
			end
			
			println("size(list)")
			println(size(list))
			
			return list	
		end
		
		function count()
			bd = JuWebRepository.get_db()
			sql = "SELECT count(*) FROM tracks"
			count = SQLite.query(bd, sql)
			println(size(count))
			return size(count)
		end
	
		this.create=create
		this.select=select
		this.update=update
		this.delete=delete
		this.list=list
		this.count=count
	
		return this
	
	end

end
