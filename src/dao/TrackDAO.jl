# ============== #
#     DAO		 #
# ============== #

using SQLite

include("../config/Constants.jl") #constants


include(joinpath(REPOSITORY_PATH,"Repository.jl"))
include(joinpath(MODEL_PATH,"TrackModel.jl"))
include("AbstractDAO.jl")


type TrackDAO <: AbstractDAO

	insert::Function
	select::Function
	alter::Function
	delete::Function
	list_all::Function
	count::Function
	
	function TrackDAO()
	
		this = new()
		
		function insert()
			println("insert()")
		end
		
		function select(id::Int)
			println("TrackDAO.select(id)")
			
			bd = Repository.get_db()
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
		
		function alter(id::Int)
			println("alter()")
		end
		
		function delete()
			println("delete()")
		end
		
		function list_all()
			println("Acessing TrackDAO! Interface with databases / repositories.  list_all()")
			
			bd = Repository.get_db()
			sql = "SELECT * FROM tracks"
			query = SQLite.query(bd, sql)
			
			#list
			list = TrackModel[]
			
			println("oi")
			
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
			
			println("eita")
			println(size(list))
			
			return list	
		end
		
		function count()
			bd = Repository.get_db()
			sql = "SELECT count(*) FROM tracks"
			count = SQLite.query(bd, sql)
			
			println(size(count))

			return size(count)
			
			#db = SQLiteDB("quotes.db")
			#res = query(db,"select count(*) from quotes");
			#size(res)
			#res[1][1]; # => 36
			
		end
	
		this.insert=insert
		this.select=select
		this.alter=alter
		this.delete=delete
		this.list_all=list_all
		this.count=count
	
		return this
	
	end

end