# ==================== #
#   PolsarController   # 
# ==================== #

using SQLite
using ImageView, Images 
using FileIO, QuartzImageIO

#service layer

#include("../../ZoomScript.jl")
include("../config/Constants.jl") #constants
include(joinpath(VIEW_PATH,"View.jl"))
include(joinpath(SERVICE_PATH,"ImageService.jl"))


type PolsarController
		
	#track_service::TrackService #service
		
	#methods
	index::Function
	image::Function
	img_cut::Function
	return_img::Function
	generate_image::Function
	
	
	
	#construtor
	function PolsarController()
		
		this = new()
		#this.track_service = TrackService()
		
		println("criado PolsarController")	
		
		function index(req::Request,res::Response)
			println("Acessing PolsarController! Interface with views. Called index()")
			#rendering a view
			println("Rendering PolsarView")
			polsar_view = View("index-angular.html")
			res.data = polsar_view.render()
			println("Returning PolsarView")
			#returning a view
			return res
		end
		
		
		function image(req::Request,res::Response)
			#(ismatch(r"^",req.resource))
			
			println("testeeeeea")
			println(req.resource)
			
			
			x = split(req.resource,'/')[3]
			println(x)
			z = split(req.resource,'/')[5]
			println(z)
			image_polsar_path = joinpath(RESOURCE_PATH,"img.png")
			if ImageService().ZoomScript(joinpath(IMAGE_PATH,"SanAnd_05508_10007_005_100114_L090HHHH_CX_01.mlc"),
										 joinpath(IMAGE_PATH,"SanAnd_05508_10007_005_100114_L090HVHV_CX_01.mlc"),
										 joinpath(IMAGE_PATH,"SanAnd_05508_10007_005_100114_L090VVVV_CX_01.mlc"),
										 parse(Int, z),
										 image_polsar_path) == true
				
				#file_response!(req, image_polsar_path, res)
				res.headers = file_headers(image_polsar_path)
				res.status = 200
				res.data = open(read, image_polsar_path)
				return res
				
			end
		end
		
		
		
		
		
		#TODO adicionar métodos nos utils
		function serve_static_file(req::Request, res::Response)
		  f = file_path(req.resource)
		  res.status = 200
		  res.headers = file_headers(f)
		  res.data = open(read, f)
		  return res
     	end
		file_extension(f) = ormatch(match(r"(?<=\.)[^\.\\/]*$", f), "")
		file_headers(f) = Dict{AbstractString, AbstractString}("Content-Type" => get(mimetypes, file_extension(f), "application/octet-stream"))
		ormatch(r::RegexMatch, x) = r.match
		ormatch(r::Void, x) = x
		#TODO adicionar métodos nos utils

		
		
		
		function img_cut(req::Request,res::Response)
			#valores via url
			xStart = parse(Int, split(req.resource,'/')[3])
			xEnd = parse(Int,split(req.resource,'/')[4])
			yStart = parse(Int, split(req.resource,'/')[5])
			yEnd = parse(Int, split(req.resource,'/')[6])
			println(string(req.resource))
			img_url = joinpath(RESOURCE_PATH,"imagem_cortada.png")
			imgToCut = load(joinpath(RESOURCE_PATH,"img.png"))
			cutImg = subim(imgToCut, "x", xStart:xEnd, "y",yStart:yEnd)
			saveimg_time = Images.save(img_url,convert(Image,cutImg))
			image_polsar_path = joinpath(RESOURCE_PATH,"imagem_cortada.png")
			#old
			#file_response!(req, image_polsar_path, res)
			#old
			#new
			res.headers = file_headers(img_url)
			res.status = 200
			res.data = open(read, img_url)
			return res
			#new
		end
		
		
		function generate_image(req::Request,res::Response)
			#valores via url
			url = req.resource
			query_string_params = url[search(url, '?')+1 : end] #substring indice inicial, final
			println(query_string_params) 
			#params in Dict - post in url
			params::Dict{AbstractString,AbstractString}
			params = HttpCommon.parsequerystring(query_string_params) #cria Dict com os params separados. ParÂmetros que foram passados pela URL
			
			#print params no console de julia
			for (n, f) in enumerate(params)
				println(string(n," => ",f))
			end
			
			#pegando parametros
			algorithm = get(params, "algorithm", "pauli") #terceiro param é o default value
			summary_size = get(params, "ssize", nothing)
			xStart = get(params, "xStart", nothing) 
			xEnd = get(params, "xEnd", nothing)
			yStart = get(params, "yStart", nothing)
			yEnd = get(params, "yEnd", nothing)
			
			#parse to Int	
			summary_size = try parse(Int, summary_size) end
			xStart = try parse(Int, xStart) end
			xEnd = try parse(Int, xEnd) end
			yStart = try parse(Int, yStart) end
			yEnd = try parse(Int, yEnd) end
			
			println(algorithm)
			println(summary_size)
			println(xStart)
			println(xEnd)
			println(yStart)
			println(yEnd)

			#xStart = parse(Int, split(req.resource,'/')[3])
			#xEnd = parse(Int,split(req.resource,'/')[4])
			#yStart = parse(Int, split(req.resource,'/')[5])
			#yEnd = parse(Int, split(req.resource,'/')[6])
			
						
			println(string(req.resource))
			
			
			#cortar imagem
			println("Cortando imagem...")
			img_url = joinpath(RESOURCE_PATH,"imagem_cortada.png")
			imgToCut = load(joinpath(RESOURCE_PATH,"img.png"))
			cuttedImg = subim(imgToCut, "x", xStart:xEnd, "y",yStart:yEnd)
			

			
			#aplicar algoritmo na imagem cortada
			println("Aplicando algoritmo...")
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
				cuttedImg = ImageService().bilinear_interpolation(cuttedImg, 4.5, 5.5)
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
			
			
			
			
			
			#salvar imagem cortada, já com algoritmo aplicado
			println("Salvando imagem processada...")
			saveimg_time = Images.save(img_url,convert(Image,cuttedImg)) #salvando img em img_url

						
						
			#old
			#file_response!(req, image_polsar_path, res)
			#old
		
			#new
			res.headers = file_headers(img_url)
			res.status = 200
			res.data = open(read, img_url)
			return res
			#new
			
		end
		
		
		function return_img()
			image_polsar_path = joinpath(RESOURCE_PATH,"imagem_cortada.png")
			file_response!(req, image_polsar_path, res)
		end
		
		
		
		#set methods
		this.index = index		
		this.image = image
		this.img_cut = img_cut
		this.return_img = return_img
		this.generate_image = generate_image
		
		return this
		
	end

end