# ============== #
#   JuWeb v1.0   #
# ============== #

module JuWeb

using HttpServer, Mustache, Requests

include("config/constants.jl") #constants

print_with_color(:yellow,"    _                   _ \n")
print_with_color(:yellow,"   | |_ _  __ __  ____ | |__\n")
print_with_color(:yellow," __| | | ||  /  ||  -_||  - |\n")
print_with_color(:yellow,"|____|___| \\/ \\/ |____||____|   v1.0  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
print_with_color(:yellow,"\n\n")


println(JUWEB_PATH)
cd(JUWEB_PATH) #manter no path do projeto



#baixar binários das imagens, caso não tenha
function dlimages()
    isdir(IMAGE_PATH) || mkpath(IMAGE_PATH) #caso n tenha pasta, criá-la
	fnames = ["SanAnd_05508_10007_005_100114_L090HHHH_CX_01.mlc",
			  "SanAnd_05508_10007_005_100114_L090HVHV_CX_01.mlc",
			  "SanAnd_05508_10007_005_100114_L090VVVV_CX_01.mlc"]
	furl= ["https://bitbucket.org/lucdms/juweb_images/raw/6ff0874260fea6b13ede7572b08f14ad178140a3/Images/SanAnd_05508_10007_005_100114_L090HHHH_CX_01.mlc",
			  "https://bitbucket.org/lucdms/juweb_images/raw/6ff0874260fea6b13ede7572b08f14ad178140a3/Images/SanAnd_05508_10007_005_100114_L090HVHV_CX_01.mlc",
			  "https://bitbucket.org/lucdms/juweb_images/raw/6ff0874260fea6b13ede7572b08f14ad178140a3/Images/SanAnd_05508_10007_005_100114_L090VVVV_CX_01.mlc"]	  
			  
	for i = 1:length(fnames)		
		if !isfile(joinpath(IMAGE_PATH, fnames[i]))
			println(string("Efetuando download da imagem ", fnames[i] ," e adicionando-a no projeto. Por favor, aguarde."))		
			#web = Requests.get(furl[i])
			#Requests.save(web, joinpath(IMAGE_PATH, fnames[i]))
			
			
			stream = Requests.get_streaming(furl[i])

			open(joinpath(IMAGE_PATH, fnames[i]), "w") do file
			  while !eof(stream)
				write(file, readavailable(stream))
				print_with_color(:blue,"|")
			  end
			end
		
			
		end	
	end
end
dlimages()




include("JuWebApp.jl") #app
include("JuWebServer.jl") #server
include("utils/http_utils.jl") #http util
include("route/JuWebRouter.jl") #roteador
include("route/JuWebRouteMapper.jl") #map das rotas


router = JuWebRouter()
rmapper = JuWebRouteMapper(router)
rmapper.map_routes()
app = JuWebApp() #start http
server = JuWebServer(app,"localhost",8000)
println(server.info())
server.run()




end #module
