![JUWEB LOGO](https://scontent-gru2-1.xx.fbcdn.net/v/t1.0-9/16508576_1264883806922556_9165801245734248889_n.jpg?oh=a1a7d578720ea39064aaf1313fb7dec3&oe=594B3133)

https://drive.google.com/file/d/0ByBvdsbTIBi_WkRSQUxkd3FJOUk/view?usp=sharing

# JuWeb v1.0

```
    _                   _ 
   | |_ _  __ __  ____ | |__
 __| | | ||  /  ||  -_||  - |
|____|___| \/ \/ |____||____|	v1.0

```


### Juweb came to facilitate!

Juweb is a Web Framework that uses MVC paradigm, whose purpose is the promotion of easy development of modern web applications using tools, modules and methods of the HTTP protocol and the libraries available in the Julia language. Juweb is still in development, and is being implemented for the most part in Julia, which is a high-level, high-performance, dynamic programming language with just-in-time (JIT) compilation.

To configure and run the Polsar application on JuWeb, you must do the following:
```julia
Requirements:
- Install Julia-0.4.6;
- Add Packages:
	Pkg.add("HttpServer")
	Pkg.add("Mustache")
	Pkg.add("Requests")
	Pkg.add("SQLite")
	Pkg.add("JSON")
	Pkg.add("ImageView")
	Pkg.add("QuartzImageIO")
	Pkg.add("ImageMagick")	
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

 ![JUWEB DOWNLOADING](https://scontent-gru2-1.xx.fbcdn.net/v/t1.0-9/16681761_1267442713333332_2627546624307731990_n.jpg?oh=ba4402613070f687eb9423ad0860a70d&oe=59396DDD)


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

	#methods
	index::Function
	sum::Function
	mult_index::Function
	mult_action::Function
	
	#constructor
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
		
		#set methods
		this.index = index	
		this.sum = sum
		this.mult_index = mult_index
		this.mult_action = mult_action
		
		return this
		
	end

end
```

### Routes

In "./JuWeb/src/route/routes.jl" add the code:

```julia
include(joinpath(CONTROLLER_PATH,"MyController.jl"))
my_controller = MyController()

#mycontroller index page
router.register_controller(GET,"/mycontroller\$",my_controller.index)

#mycontroller sum service route
router.register_controller(GET,"/mycontroller/sum\\?([\\w-]+(=[\\w-]*)?(&[\\w-]+(=[\\w-]*)?)*)?\$", my_controller.sum)

#mycontroller mult service route
router.register_controller(GET,"/mycontroller/mult\$",my_controller.mult_index)
router.register_controller(POST,"/mycontroller/mult_action\$",my_controller.mult_action)
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

![JUWEB WORKING](https://scontent-gru2-1.xx.fbcdn.net/v/t1.0-9/16682012_1264883960255874_8231054305525312709_n.jpg?oh=46108a8f860e4319ddfb9be27db21067&oe=594BD199)

https://drive.google.com/file/d/0ByBvdsbTIBi_UVNqWDFJNGlUWk0/view?usp=sharing


Thank you.

Luciano Melo.
lucdms@gmail.com

