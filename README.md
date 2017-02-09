![JUWEB LOGO](https://drive.google.com/file/d/0ByBvdsbTIBi_WkRSQUxkd3FJOUk/view?usp=sharing)
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
	Pkg.add("SQLite")
	Pkg.add("JSON")
	Pkg.add("ImageView")
	Pkg.add("QuartzImageIO")
	Pkg.add("ImageMagick")	
	
NOTE: Any compatibility issues, or exceptions, remove the folders from the Julia libraries and try the above procedure again.
		- On Windows:
			"C:\Users\nomedousuario\.julia\v0.4"
			"C:\Users\nomedousuario\.julia\lib\v0.4"
	

- Set the database directory in the file: config / constants.jl, more specifically the constant DB_FILE_NAME;

- After all this, just include the Run.jl file, located in JuWeb's main directory, for example:

REPL:

$> julia cd("C:\\Users\\lucianomelo\\Desktop\\workspace\\juweb")
$> julia include("Run.jl")


Acessar:
http://localhost:8000/polsar
http://localhost:8000/post_example
http://localhost:8000/tracks
http://localhost:8000/tracks/4


```


JuWeb Working:

![JUWEB WORKING](https://lh5.googleusercontent.com/XE92nPQurEEojJK0FHjToQniDBrSZLd7k7oMec5g-7-0_27TfC2-DcaQ49fNmjRteX4j9dc3=w2560-h475-rw)

https://drive.google.com/file/d/0ByBvdsbTIBi_UVNqWDFJNGlUWk0/view?usp=sharing


Thank you.

Luciano Melo.
lucdms@gmail.com
