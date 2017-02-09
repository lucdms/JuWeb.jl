include("track.jl")

using JSON

include("../db/repository.jl")
#using RepositoryConn
#println("using RepositoryConn")


function teste()

	id_number = 2

	bd = RepositoryConn.get_database()
	sql = string("SELECT * FROM tracks where TrackId=",id_number)
	query = SQLite.query(bd, sql)

	println("1")
		
		println("1.1.")
		t = Track()
		println(t)
		
		println("1.dsd1")
		t.track_id = string(query[1,1].value)
		println(t)
		#track.setTrackId(string(query[1,1].value))
		println(t)
		t.name = string(query[1,2].value)
		println(t)
		t.album_id = string(query[1,3].value)
		println(t)
		t.media_type_id = string(query[1,4].value)
		
		println(t)
		t.genre_id = string(query[1,5].value)
		
		try	
			t.composer = string(query[1,6].value)
		catch e
			println("caught an error $e")
			println("but we can continue with execution")
			t.composer = nothing
		end
		
		println(t)
	  
		println(t.getJSON())
end



function new_t()

	tr = Track()
	tr.track_id = "euiaeuhiueh"
	
	tr.print_track()

end

#start test
teste()
new_t()
