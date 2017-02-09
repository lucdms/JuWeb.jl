# ============================ #
#     Routes (Services Map)	   #
# ============================ #



#controllers
include("../controller/TrackController.jl")
include("../controller/PolsarController.jl") #controler
include("../controller/HomeController.jl") #controler
track_controller = TrackController()
polsar_controller = PolsarController()
home_controller = HomeController()



#ROTAS: regex_url -> method


#get
router.register_controller(GET,"/\$",polsar_controller.index)
router.register_controller(GET,"/polsar\$",polsar_controller.index)
router.register_controller(GET,"/image/(\\d+)/(\\d+)/(\\d+)\$",polsar_controller.image)

router.register_controller(GET,"/image/services/generateImage\\?([\\w-]+(=[\\w-]*)?(&[\\w-]+(=[\\w-]*)?)*)?\$",polsar_controller.generate_image)

router.register_controller(GET,"/imgCut/(\\d+)/(\\d+)/(\\d+)/(\\d+)\$",polsar_controller.img_cut)
router.register_controller(GET,"/cutImage\$",polsar_controller.return_img)
router.register_controller(GET,"/tracks\$",track_controller.list_all)
router.register_controller(GET,"/tracks\\?([\\w-]+(=[\\w-]*)?(&[\\w-]+(=[\\w-]*)?)*)?\$",track_controller.test_params)
router.register_controller(GET,"/tracks/(\\d+)\$",track_controller.select)


#post
router.register_controller(GET,"/post_example\$",home_controller.post_example) #post_example
router.register_controller(POST,"/post_action\$",home_controller.post_action) #submit


#add routes here


