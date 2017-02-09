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


type JuWebRouter

	#atributes
	routes::Dict{Any,Function}
	
	#methods
	register_controller::Function
	get_method::Function
	default_controller::Function
	
	function JuWebRouter()
	
		this = new()
		this.routes = Dict()
	
	
		#mapeia as rotas dos serviços web
		function register_controller(method::Any, url::Any, controller::Function)
			if haskey(this.routes, url)
				println("Ja existe uma rota com este nome! Tente adicionar outra url.\n")	
			else
				#println("register_controller()")
				this.routes[url] = controller 
				println(string("Mapped ""{[$url],methods=[$method],controller=[$controller]}"""))
			end
		end
		
		
		
		function resolve(url) #TODO avaliar via isMatch (REGEX)
			println("resolve(url)")
			println(keys(this.routes))
			if haskey(this.routes,url)#callback
				return this.routes[url]
			end
			return this.default_controller #caso não tenha call, default method
		end
		
		
		
		function get_method(req::Request, res::Response) # faz o que a resolve() se propôs a fazer
			url = req.resource
			println("Acessing Route! Interface with controllers, finding route...")
			#analisar se é arquivo/resource do server
			#println(string("Analisar se a rota: ",url," é um arquivo do servidor..."))
			if is_static_file(url)
				println("A rota eh um arquivo no servidor...")
				return serve_static_file(req::Request, res::Response)
			else
				println("A rota nao eh um arquivo no servidor...")
			end
			#match a rota pelo REGEX
			#a regex correta, como exemplo: ismatch(Regex("/image/([0-9])/([0-9])/([0-9])\$"), "/image/1/1/2")		
			#http://docs.julialang.org/en/release-0.5/manual/strings/
			#for para buscar rota, aplicando regras de regex (expressões regulares)
			for regex_url in get_keys()
				#println(string("url_digitada=",url))
				#println(string("Regex(string(regex_url))=",string(regex_url,"\\$")))
				#rgx=replace(regex_url, "\\", "\\\\") 	
				#rgx = string(regex_url,"\$") #adequação com regex de julia	
				#println(r)
				#println(url)
				if ismatch(Regex(regex_url), url)
					println(string("Rota encontrada para a URL ",url," que invoca o metodo de nome ",this.routes[regex_url]))
					return this.routes[regex_url](req,res) #call function of controller
				end
			end
			println(string("Nao existe nenhuma rota denominada: ",url))
			return this.default_controller()
		end
		

		
		#teste
		function route(params...; with::Dict = Dict{Any,Any}(), named = :id)
		  extra_params = Dict(:with => with)
		  #named = named == :__anonymous_route ? route_name(params) : named
		  println(params)
		  println(named)
		  println(extra_params)
		end
		
		
		
		function get_keys()
			#retorna os índices da Dict de rotas|
			#println("get_keys()")
			return collect(keys(this.routes))
		end			
			
			
		
		function default_controller()
			println("default_controller()")
			res = Response()
			res.status = 404
			res.data   = "Requested resource not found"
			return res
		end
		
		
		
		#methods for files
		function is_static_file(resource::AbstractString)
			println(string(file_path(resource)))
			isfile(file_path(resource))
		end
		
		
		
		function file_path(resource::AbstractString)
			#println(string("app","resources",resource[2:end]))
			return string(abspath("resources",resource[2:end])) #file folder
		end
		
		
		
		function serve_static_file(req::Request, res::Response)
		  f = file_path(req.resource)
		  res.status = 200
		  res.headers = file_headers(f)
		  res.data = open(read, f)
		  return res
     	end
		
		
		
		file_extension(f) = ormatch(match(r"(?<=\.)[^\.\\/]*$", f), "")
		file_headers(f) = Dict{AbstractString, AbstractString}("Content-Type" => get(mimetypes, file_extension(f), "application/octet-stream"))

		ormatch(r::RegexMatch, x) = r.match
		ormatch(r::Void, x) = x
		
		
		#setting obj methods
		this.register_controller = register_controller
		this.default_controller = default_controller
		this.get_method = get_method
		
		return this
	
	end
	


end


# R O U T E R _ I N S T A N C E 
export router
router = JuWebRouter()




