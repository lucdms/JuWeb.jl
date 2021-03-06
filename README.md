![JUWEB LOGO](https://i.imgur.com/LleHnt4.png)

# JuWeb v1.0

```
    _                   _ 
   | |_ _  __ __  ____ | |__
 __| | | ||  /  ||  -_||  - |
|____|___| \/ \/ |____||____|	v1.0

```


### Came to facilitate!

Juweb is a Web Framework that uses MVC paradigm, whose purpose is the promotion of easy development of modern web applications using tools, modules and methods of the HTTP protocol and the libraries available in the Julia language. Juweb is still in development, and is being implemented for the most part in Julia, which is a high-level, high-performance, dynamic programming language with just-in-time (JIT) compilation.

To configure and run the Polsar application on JuWeb, you must do the following:
```julia
Requirements:
- Julia-0.4.7;
- Packages:
	Pkg.add("HttpServer")
	Pkg.add("Mustache")
	Pkg.add("Requests")
	Pkg.add("SQLite")
	Pkg.add("JSON")
	Pkg.add("ImageView")
	Pkg.add("QuartzImageIO")
	Pkg.add("ImageMagick")	
	
On UNIX: You need to install the cmake command for the platform for build the HttpServer package:
	Installation by a PPA (Upgrade to 3.2)
		sudo apt-get install software-properties-common
		sudo add-apt-repository ppa:george-edison55/cmake-3.x
		sudo apt-get update
	
	When cmake is not yet installed:
		sudo apt-get install cmake
	
	When cmake is already installed:
		sudo apt-get upgrade
		
	Just Pkg.build("HttpServer")
```
NOTE: Any compatibility issues, or exceptions, remove the folders from the Julia libraries and try the above procedure again.
```
		- On Windows:
			"C:\Users\username\.julia\v0.4"
			"C:\Users\username\.julia\lib\v0.4"
			or similar
```

- Just include the REPL:

For users:
```julia
Pkg.clone("https://github.com/lucdms/JuWeb.jl.git")
push!(LOAD_PATH, Base.LOAD_CACHE_PATH[1])
using JuWeb
```

For developers:
```
It is advisable to clone the project "https://github.com/lucdms/JuWeb.jl.git" with the GIT program, 
in the "C:\Users\username\.julia\v0.4\JuWeb" (packages repository).
```

NOTE: JuWeb has already been programmed to download the binaries of the necessary images automatically to the project root
however, this may be more time-consuming than downloading it directly from the links (below). Therefore, you have both options 
to download, being at your discretion the choice of how to download.
```
https://bitbucket.org/lucdms/juweb_images/raw/6ff0874260fea6b13ede7572b08f14ad178140a3/Images/SanAnd_05508_10007_005_100114_L090HHHH_CX_01.mlc
https://bitbucket.org/lucdms/juweb_images/raw/6ff0874260fea6b13ede7572b08f14ad178140a3/Images/SanAnd_05508_10007_005_100114_L090HVHV_CX_01.mlc
https://bitbucket.org/lucdms/juweb_images/raw/6ff0874260fea6b13ede7572b08f14ad178140a3/Images/SanAnd_05508_10007_005_100114_L090VVVV_CX_01.mlc
```

This is the folder/directory that the images should be:
```
".\JuWeb\src\Images\SanAnd_05508_10007_005_100114_L090HHHH_CX_01.mlc"
".\JuWeb\src\Images\SanAnd_05508_10007_005_100114_L090HVHV_CX_01.mlc"
".\JuWeb\src\Images\SanAnd_05508_10007_005_100114_L090VVVV_CX_01.mlc"
```

Follow the image of JuWeb by downloading images automatically:

 ![JUWEB DOWN](https://i.imgur.com/y9JUmWW.jpg)


### Then just access:
```
http://localhost:8000/polsar
http://localhost:8000/post_example
http://localhost:8000/tracks
http://localhost:8000/tracks/4
```




## Our first contact with JuWeb:

### Controller

Now let us create actual source files under the JuWeb project. 
First we need to create a controller called MyController.
To do this, create MyController.jl file under the "./JuWeb/src/controller/MyController.jl".

```julia
include(joinpath(VIEW_PATH,"View.jl"))

type MyController

	index::Function
	sum::Function
	mult_index::Function
	mult_action::Function
	
	
	function MyController()
		
		this = new()
				
		function index(req::Request,res::Response)
			my_view = View("myPage.html")			
			res.data = my_view.render()
			return res
		end
		
		function sum(req::Request,res::Response)
			url = req.resource
			query_string_params = url[search(url, '?')+1 : end]
			println(query_string_params) 
			params::Dict{AbstractString,AbstractString}
			params = HttpCommon.parsequerystring(query_string_params) #Dict with params in URL
			default_x = 0
			default_y = 0
			x = parse(Int, get(params, "x", default_x))
			y = parse(Int, get(params, "y", default_y))
			sum = x + y
			return string(sum)
		end
		
		function mult_index(req::Request,res::Response)
			post_view = View("post_mult.html")
			res.data = post_view.render()
			return res
		end
		
		function convert(a::Array{UInt8,1})
			i = findfirst(a .== 0)
			if i == 0
			        s = ASCIIString(a)
			else
				s = ASCIIString(a[1:i-1])
			end
			return s
		end
		
		function mult_action(req::Request,res::Response)
			res.status = 200
			params::Dict{AbstractString,AbstractString}
			params = HttpCommon.parsequerystring(convert(req.data))
			default_x = 0
			default_y = 0
			x = parse(Int, get(params, "x", default_x))
			y = parse(Int, get(params, "y", default_y))
			mult = x * y
			return string(mult)
		end
		
		
		this.index = index	
		this.sum = sum
		this.mult_index = mult_index
		this.mult_action = mult_action
		
		
		return this
		
	end

end
```

### Routes

In "./JuWeb/src/route/JuWebRouteMapper.jl" add the code:

```julia
include(joinpath(CONTROLLER_PATH,"MyController.jl"))
my_controller = MyController()

#mycontroller index page
router.register_controller(GET,"/mycontroller(\/)?\$",my_controller.index)

#mycontroller sum service route
router.register_controller(GET,"/mycontroller/sum\\?([\\w-]+(=[\\w-]*)?(&[\\w-]+(=[\\w-]*)?)*)?\$", my_controller.sum)

#mycontroller mult service route
router.register_controller(GET,"/mycontroller/mult(\/)?\$",my_controller.mult_index)
router.register_controller(POST,"/mycontroller/mult_action(\/)?\$",my_controller.mult_action)
```


### Views

In "./JuWeb/src/resources/mypage.html" add the code:
```
<!DOCTYPE html>
<html>
 <body>
  <h1>My First Page</h1>
  <p>JuWeb!! Taadaaaa!</p>
 </body>
</html>
```


In "./JuWeb/src/resources/post_mult.html" add the code:
```
<!DOCTYPE html>
<html>
	<head></head>
	<body>
		<form action="/mycontroller/mult_action" method="POST">
		  x: <input type="text" name="x"><br>
		  y: <input type="text" name="y"><br>
		  <input type="submit" value="Submit">
		</form>
	</body>
</html>
```

### Try:
```
http://localhost:8000/mycontroller
http://localhost:8000/mycontroller/sum?y=3&x=49
http://localhost:8000/mycontroller/sum?x=49&y=3
http://localhost:8000/mycontroller/mult
```




JuWeb Working:

![JUWEB WORKING](https://i.imgur.com/iIsD5sT.jpg)



Thank you.

Luciano Melo.
lucdms@gmail.com

