using JSON

include("AbstractModel.jl")

type TrackModel <: AbstractModel

	#attributes
	track_id
	name
	album_id
	media_type_id
	genre_id
	composer

	function TrackModel()
		return new()
	end
	
	
end
