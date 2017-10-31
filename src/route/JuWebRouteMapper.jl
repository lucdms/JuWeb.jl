# ============================ #
#     Routes (Services Map)	   #
# ============================ #


#controllers
include("../controller/TrackController.jl")
include("../controller/PolsarController.jl") #controller
include("../controller/HomeController.jl") #controller
include("../controller/LoginController.jl") #controller

#ROTAS: regex_url -> method

# (\/)?  -> optional /

#  \\?([\\w-]+(=[\\w-]*)?(&[\\w-]+(=[\\w-]*)?)*)?\$   ->   url paramsm, example: localhost:8080/service?param=1&paramx=fdff

#  ^    ->    start of word 

#  \$   ->    end of word,   "\" indicates $ is a char


export JuWebRouteMapper

type JuWebRouteMapper

	map_routes::Function

	#construct
	function JuWebRouteMapper(router::JuWebRouter)
	
		this = new()
	
		function map_routes()

			#controllers
			track_controller = TrackController()
			polsar_controller = PolsarController()
			home_controller = HomeController()
			login_controller = LoginController()
	
		
			router.register_controller(GET,"^/\$",polsar_controller.index)
			router.register_controller(GET,"/polsar(\/)?\$",polsar_controller.index)
			router.register_controller(GET,"/polsar/homeImage\\?([\\w-]+(=[\\w-]*)?(&[\\w-]+(=[\\w-]*)?)*)?\$",polsar_controller.main_image)
			router.register_controller(GET,"/polsar/services/generateImage\\?([\\w-]+(=[\\w-]*)?(&[\\w-]+(=[\\w-]*)?)*)?\$",polsar_controller.generate_image)
			router.register_controller(GET,"/polsar/services/imgCut\\?([\\w-]+(=[\\w-]*)?(&[\\w-]+(=[\\w-]*)?)*)?\$",polsar_controller.img_cut)		
			router.register_controller(GET,"/tracks(\/)?\$",track_controller.list)	
			router.register_controller(GET,"/tracks/(\\d+)\$",track_controller.select)			
			router.register_controller(GET,"/home\\?([\\w-]+(=[\\w-]*)?(&[\\w-]+(=[\\w-]*)?)*)?\$",home_controller.test_params) #params example
			router.register_controller(GET,"/post_example(\/)?\$",home_controller.post_example) #post_example
			router.register_controller(POST,"/post_action(\/)?\$",home_controller.post_action) #action
			router.register_controller(GET,"/login(\/)?\$",login_controller.login_page) #login_example
			router.register_controller(POST,"/login_action(\/)?\$",login_controller.login_action) #action
			#add new routes here...
			
			
			
		end

		
		this.map_routes = map_routes
		
		return this
		
	end
	
	
end
