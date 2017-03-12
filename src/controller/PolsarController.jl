# ==================== #
#   PolsarController   # 
# ==================== #

using SQLite
using ImageView, Images 
using FileIO, QuartzImageIO


include("../config/constants.jl") #constants
include(joinpath(VIEW_PATH,"View.jl"))
include(joinpath(SERVICE_PATH,"ImageService.jl"))


#PolsarController, interface with views and users
type PolsarController
				
	
	#methods
	index::Function
	main_image::Function
	generate_image::Function
	img_cut::Function

	
	#constructor
	function PolsarController()
		
		this = new()		
		
		function index(req::Request,res::Response)
			#rendering a view
			println("Rendering PolsarView")
			polsar_view = View("index-angular.html")
			res.data = polsar_view.render()
			println("Returning PolsarView")
			return res
		end
		
		
		function main_image(req::Request,res::Response)			
			println("generate main image...")
			url = req.resource
			query_string_params = url[search(url, '?')+1 : end] #substring indice inicial, final
			params::Dict{AbstractString,AbstractString}
			params = HttpCommon.parsequerystring(query_string_params) #cria Dict com os params separados. ParÂmetros que foram passados pela URL
			#params
			for (n, f) in enumerate(params)
				println(string(n," => ",f))
			end
			x = get(params, "x", "1") #terceiro param é o default value
			y = get(params, "y", "2") #terceiro param é o default value
			z = get(params, "z", "10") #terceiro param é o default value			
			main_image_polsar_path = joinpath(RESOURCE_PATH,"img.png")
			#generate png from binary satellites images and send to home
			if ImageService().ZoomScript(joinpath(IMAGE_PATH,"SanAnd_05508_10007_005_100114_L090HHHH_CX_01.mlc"),
										 joinpath(IMAGE_PATH,"SanAnd_05508_10007_005_100114_L090HVHV_CX_01.mlc"),
										 joinpath(IMAGE_PATH,"SanAnd_05508_10007_005_100114_L090VVVV_CX_01.mlc"),
										 parse(Int, z),
										 main_image_polsar_path) == true
				
				
				res.status = 200
				res.data = open(read, main_image_polsar_path)
				res.headers = Dict( "Server"     => "Julia/$VERSION",
								  "Content-Type" => "image/png",
								  "Date"         => Dates.format(now(Dates.UTC), Dates.RFC1123Format) )
				return res	
				
			end
		end
		

		function img_cut(req::Request,res::Response)
			#valores via url
			url = req.resource
			query_string_params = url[search(url, '?')+1 : end] #substring indice inicial, final
			params::Dict{AbstractString,AbstractString}
			params = HttpCommon.parsequerystring(query_string_params) #cria Dict com os params separados. ParÂmetros que foram passados pela URL
			#params
			for (n, f) in enumerate(params)
				println(string(n," => ",f))
			end
			xStart = get(params, "xStart", "1") #terceiro param é o default value
			xEnd = get(params, "xEnd", "2") #terceiro param é o default value
			yStart = get(params, "yStart", "10") #terceiro param é o default value			
			yEnd = get(params, "yEnd", "10") #terceiro param é o default value			
			#parse to int	
			xStart = try parse(Int, xStart) end
			xEnd = try parse(Int, xEnd) end
			yStart = try parse(Int, yStart) end
			yEnd = try parse(Int, yEnd) end	
			println(string(req.resource))
			img_url = joinpath(RESOURCE_PATH,"imagem_cortada.png")
			imgToCut = load(joinpath(RESOURCE_PATH,"img.png"))
			cutImg = subim(imgToCut, "x", xStart:xEnd, "y",yStart:yEnd)
			saveimg_time = Images.save(img_url,convert(Image,cutImg))
			image_polsar_path = joinpath(RESOURCE_PATH,"imagem_cortada.png")
			res.status = 200
			res.data = open(read, image_polsar_path)
			res.headers = Dict( "Server"     => "Julia/$VERSION",
							  "Content-Type" => "image/png",
							  "Date"         => Dates.format(now(Dates.UTC), Dates.RFC1123Format) )
			return res
		end
		
		
		function generate_image(req::Request,res::Response)
			#params via url
			url = req.resource
			query_string_params = url[search(url, '?')+1 : end] #substring indice inicial, final
			params::Dict{AbstractString,AbstractString}
			params = HttpCommon.parsequerystring(query_string_params) #cria Dict com os params separados. ParÂmetros que foram passados pela URL
			
			#print params
			for (n, f) in enumerate(params)
				println(string(n," => ",f))
			end
			
			#catch params
			algorithm = get(params, "algorithm", "pauli") #terceiro param é o default value
			summary_size = get(params, "ssize", nothing)
			xStart = get(params, "xStart", nothing) 
			xEnd = get(params, "xEnd", nothing)
			yStart = get(params, "yStart", nothing)
			yEnd = get(params, "yEnd", nothing)
			
			#parse to int	
			summary_size = try parse(Int, summary_size) end
			xStart = try parse(Int, xStart) end
			xEnd = try parse(Int, xEnd) end
			yStart = try parse(Int, yStart) end
			yEnd = try parse(Int, yEnd) end	
			
			#cut image
			println("Cortando imagem...")
			img_url = joinpath(RESOURCE_PATH,"imagem_cortada.png")
			img_to_cut = load(joinpath(RESOURCE_PATH,"img.png"))
			cuttedImg = subim(img_to_cut, "x", xStart:xEnd, "y",yStart:yEnd)
			
			#process algorithm in cutted image
			println(string("Applying algorithm ","[",algorithm,"] ..."))
			if algorithm == "pointdetector"
				cuttedImg = ImageService().pointDetector(cuttedImg)
			elseif algorithm == "pauli"
				#todo alg
			elseif algorithm == "convolucao"
				#todo alg
			elseif algorithm == "grayscale"
				cuttedImg = ImageService().tomCinza(cuttedImg)
			elseif algorithm == "blur"
				cuttedImg = ImageService().blur(cuttedImg)
			elseif algorithm == "dilate"
				cuttedImg = ImageService().dilate(cuttedImg)
			elseif algorithm == "erode"
				cuttedImg = ImageService().erode(cuttedImg)
			elseif algorithm == "bilinear_interpolation"
				#not working
				#cuttedImg = ImageService().bilinear_interpolation(cuttedImg, 4.5, 5.5)
			elseif algorithm == "morpholaplace"
				cuttedImg = ImageService().morpholaplace(cuttedImg)
			elseif algorithm == "morphogradient"
				cuttedImg = ImageService().morphogradient(cuttedImg)
			elseif algorithm == "tophat"
				cuttedImg = ImageService().tophat(cuttedImg)
			elseif algorithm == "opening"
				cuttedImg = ImageService().opening(cuttedImg)
			elseif algorithm == "closing"
				cuttedImg = ImageService().closing(cuttedImg)
			elseif algorithm == "saltpeppernoise"
				cuttedImg = ImageService().SaltPepperNoise(cuttedImg)
			end
						
			#save processed image
			println("Saving processed image...")
			saveimg_time = Images.save(img_url,convert(Image,cuttedImg)) #saving in img_url
		
			#response
			res.status = 200
			res.data = open(read, img_url)
			res.headers = Dict( "Server"     => "Julia/$VERSION",
							  "Content-Type" => "image/png",
							  "Date"         => Dates.format(now(Dates.UTC), Dates.RFC1123Format) )
						
			return res

		end
		

		#set methods
		this.index = index		
		this.main_image = main_image
		this.generate_image = generate_image
		this.img_cut = img_cut

		
		return this
		
	end

end