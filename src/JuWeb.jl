# ======================== #
#   JuWebApp+JuWebServer   #
# ======================== #

module JuWeb

using HttpServer, Mustache

include("config/Constants.jl") #constants


println(JUWEB_PATH)
cd(JUWEB_PATH) #manter no path do projeto


include("JuWebApp.jl")
include("JuWebServer.jl")
include("utils/http_utils.jl") #utils

#include("repo/Repository.jl") #repository, daos


#rotas
include("route/JuWebRouter.jl")
include("route/routes.jl")


#start http
app = JuWebApp()
server = JuWebServer(app,"localhost",8000)
server.run()


end #module
