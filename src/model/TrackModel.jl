using JSON

include("AbstractModel.jl")

type TrackModel <: AbstractModel

	#atributos da classe
	track_id
	name
	album_id
	media_type_id
	genre_id
	composer
	
	#metodos da classe
	print_track::Function
	getJSON::Function
	
	#construtores, onde serão compostos dos métodos da "classe"
	function TrackModel()
	
		this = new()
		
		#métodos são objetos dentro do construtor! (tudo é tratado como objeto em julia)
		function print_track()
			println(string("Track:",this))
		end
		
		function getJSON()
			track = Dict(
				"TrackId" => this.track_id,
				"Name" => this.name,
				"AlbumId" => this.album_id,
				"MediaTypeId" => this.media_type_id,
				"GenreId" => this.genre_id,
				"Composer" => this.composer
			)
			return JSON.json(track)
		end
		
		
		
		this.print_track = print_track
		this.getJSON = getJSON
		
		
		return this
	end
	
	
	function Track()
		this=new()
		
		#métodos são objetos dentro do construtor! (tudo é tratado como objeto em julia)
		function print_track()
			println(string("Track:",this))
		end
		

		function getJSON()
			track = Dict(
				"TrackId" => this.track_id,
				"Name" => this.name,
				"AlbumId" => this.album_id,
				"MediaTypeId" => this.media_type_id,
				"GenreId" => this.genre_id,
				"Composer" => this.composer
			)
			return JSON.json(track)
		end
		
		
		
		#set methods on new object
		this.print_track = print_track
		this.getJSON = getJSON
		
		return this
	end
	
	
	

	
	

end
