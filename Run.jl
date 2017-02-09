# ======================== #
#   JuWebApp+JuWebServer   #
# ======================== #

module Run


using HttpServer
using Mustache
#using JSON




include("JuWebApp.jl")
include("JuWebServer.jl")
include("utils/http_utils.jl") #utils
#include("config/Constants.jl") #constants
#include("repo/Repository.jl") #repository, daos




#rotas
include("route/JuWebRouter.jl")
include("route/routes.jl")





#start http
app = JuWebApp()
server = JuWebServer(app,"localhost",8000)
server.run()

#server = Server((req, res) -> app(req))
#run(server, 8000)





end #module
