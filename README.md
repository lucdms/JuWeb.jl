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
```
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
```
$> julia Pkg.clone("https://github.com/lucdms/JuWeb.jl.git")
$> julia using JuWeb
```

For developers:
```
It is advisable to clone the project "https://github.com/lucdms/JuWeb.jl.git" with the GIT program, 
in the "C:\Users\username\.julia\v0.4\JuWeb" (packages repository).
```

NOTE: JuWeb has already been programmed to download the binaries of the necessary images automatically to the project root, 
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
 ![JUWEB DOWNLOADING](https://scontent-gru2-1.xx.fbcdn.net/v/t1.0-9/16683850_1267419506668986_2113012886235174301_n.jpg?oh=9737bcdbda245c4bd5e0bde581b0081f&oe=5941B9F8)


Then just access:
```
http://localhost:8000/polsar
http://localhost:8000/post_example
http://localhost:8000/tracks
http://localhost:8000/tracks/4
```


JuWeb Working:

![JUWEB WORKING](https://scontent-gru2-1.xx.fbcdn.net/v/t1.0-9/16682012_1264883960255874_8231054305525312709_n.jpg?oh=46108a8f860e4319ddfb9be27db21067&oe=594BD199)

https://drive.google.com/file/d/0ByBvdsbTIBi_UVNqWDFJNGlUWk0/view?usp=sharing


Thank you.

Luciano Melo.
lucdms@gmail.com

