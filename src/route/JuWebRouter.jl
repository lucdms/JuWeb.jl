# ================== #
#     JuWebRouter	 #
# ================== #


export GET, POST, PUT, PATCH, DELETE

const GET     = "GET"
const POST    = "POST"
const PUT     = "PUT"
const PATCH   = "PATCH"
const DELETE  = "DELETE"


using URIParser
using HttpServer
import HttpServer.mimetypes

include(joinpath(VIEW_PATH,"View.jl"))


export JuWebRouter

type JuWebRouter

	#atributes
	routes::Dict{Any,Function}
	
	#methods
	register_controller::Function
	callback::Function

	
	function JuWebRouter()
	
		this = new()
		this.routes = Dict()
		
		#mapeia as rotas dos serviços web
		function register_controller(method::Any, url::Any, controller::Function)
			if haskey(this.routes, url)
				print_with_color(:red,string("Ja existe uma rota com este nome! Tente adicionar outra url.\n\n"))
			else
				this.routes[url] = controller 
				print_with_color(:white,string("Mapped ""{[$url],methods=[$method],controller=[$controller]}\n"""))
			end
		end

		
		function callback(req::Request, res::Response)
			url = req.resource
			println("Acessing Route! Interface with controllers, finding route...")
			#analisar se é arquivo/resource do server
			#println(string("Analisar se a rota: ",url," é um arquivo do servidor..."))
			if is_static_file(url)
				print("A rota eh um arquivo no servidor: ")
				print_with_color(:green,string(url,"\n"))
				return serve_static_file(req::Request, res::Response)
			else
				println("A rota nao eh um arquivo no servidor...")
			end
			#match a rota pelo REGEX
			#a regex correta, como exemplo: ismatch(Regex("/image/([0-9])/([0-9])/([0-9])\$"), "/image/1/1/2")		
			#http://docs.julialang.org/en/release-0.5/manual/strings/
			#for para buscar rota, aplicando regras de regex (expressões regulares)
			for regex_url in collect(keys(this.routes)) #retorna os índices da Dict de rotas
				if ismatch(Regex(regex_url), url)	
					#println(string("Rota encontrada para a URL ",url," que invoca o metodo de nome ",this.routes[regex_url]))
					print("Rota encontrada para a URL ")
					print_with_color(:green,string(url," "))
					print("que invoca o metodo de nome ")
					print_with_color(:green,string(this.routes[regex_url],"\n"))			
					return this.routes[regex_url](req,res) #call function of controller
				end
			end
			println(string("Nao existe nenhuma rota denominada: ",url))
			return controller_not_found() #caso não tenha call, default method
		end
			
			
		
		function controller_not_found()
			println("controller_not_found()")
			res = Response()
			res.status = 404
			println("Rendering 404 page")
			not_found_view = View("404.html")
			res.data = not_found_view.render() #rendering a view
			return res
		end
		
		
		
		#methods for files
		function is_static_file(resource::AbstractString)
			println(string(file_path(resource)))
			isfile(file_path(resource))
		end
		
		
		
		function file_path(resource::AbstractString)
			#println(string("app","resources",resource[2:end]))
			return string(abspath("src","resources",resource[2:end])) #file folder
		end
		
		
		
		function serve_static_file(req::Request, res::Response)
		  f = file_path(req.resource)
		  res.status = 200
		  res.headers = file_headers(f)
		  res.data = open(read, f)
		  return res
     	end
		
		
		
		#Response.headers utils
		
		function ormatch(r::RegexMatch, x)
		  return r.match
		end
		
		function ormatch(r::Void, x)
		  return x
		end
		
		function file_extension(f) 
		  ormatch(match(r"(?<=\.)[^\.\\/]*$", f), "")
		end
		
		function file_headers(f)
		  Dict{AbstractString, AbstractString}("Content-Type" => get(mimetypes, file_extension(f), "application/octet-stream"))
		end
	
		
		
		this.register_controller = register_controller
		this.callback = callback
		
		
		return this
	
	end
	
end

