
routes = Dict{Any,Function}()



println(typeof(r"^/image/(\d+)/(\d+)/(\d+)"))


routes["/api/db/tables\$"] = 
function tables()
	println("tables")
end


routes["/api/db/tables/(\\d+)\$"] =
function select()
	println("select")
end






function get_keys()
	return collect(keys(routes))
end


function go_route(url)

	for regex_url in get_keys()
	
		#m = ismatch(regex_url, url)
		#println("m = $m")
		#println(url)
		
		#if m === nothing
		#	println("not a route")
		#else
		#	println(routes[regex_url])
		#end

		if ismatch(Regex(regex_url), url)
			println(string("rota certa! ",regex_url," ",url))
			return routes[regex_url]() #invoke function controller
		else
			println("no")
		end
		
		
	end

end


function get_route(route_name::Symbol)
  haskey(routes, route_name) ? Nullable(routes()[route_name]) : Nullable()
end

#acessando site
#r = get_route(Symbol("/api/db/tables/1"))

println(get_keys())
go_route("/api/db/tables/1")

go_route("/api/db/tables")
