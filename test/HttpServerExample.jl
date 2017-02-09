using HttpServer
using HTTPClient
import HttpServer.mimetypes


function fibonacci(n)
  if n == 1 return 1 end
  if n == 2 return 1 end
  prev = BigInt(1)
  pprev = BigInt(1)
  for i=3:n
    curr = prev + pprev
    pprev = prev
    prev = curr
  end
  return prev
end

function getPredefHtml(req, s)
    return string(
    "<!DOCTYPE html>",
    "<HTML>",
      "<BODY>",
        "<H1>Spectacular PolSAR Image - Req.resource=",req.resource," RETURNS: ", s ,"</H1>",
        "<img src=\"img.png\" alt=\"PolSAR Image\" style=\"width:304px;height:228px;\">",
      "</BODY>",
    "</HTML>")
end




#teste
http = HttpHandler() do req::Request("GET","/hello/world","",""), res::Response(200,["Server" => "Julia/$VERSION",
  "Content-Type" => "image/png",
  "Content-Language" => "en",
  "Date" => Date.today()],true,false)
png = get("http://cdn.sstatic.net/stackexchange/img/logos/so/so-logo.png")
outfile = open("file.png", "w")
write(outfile, png.body.data)
close(outfile)
Response(outfile)
end
#teste








# Julia's do syntax lets you more easily pass a function as an argument
http = HttpHandler() do req::Request, res::Response

    #isso é expressão regular
    if ismatch(r"^/hello/",req.resource) # if the requested path starts with `/hello/`
      return Response(getPredefHtml(req,"Hello, It's me!"))
    elseif ismatch(r"^/fibo/(\d+)/?$",req.resource) #fibonacci service
      m = match(r"^/fibo/(\d+)/?$",req.resource)
      number = BigInt(m.captures[1])
      if number < 1 || number > 100_000
        return Response(getPredefHtml(req,"500")) #resultado do fibonacci
      else
        return Response(getPredefHtml(req,string(fibonacci(number))))
      end
    elseif ismatch(r"^/image/",req.resource)
      #retornar imagem

      return Response(pwd())
    else  #return a 404 error
      return Response(404)
    end

    #Response( ismatch(r"^/hello/",req.resource) ? string("Hello ", split(req.resource,'/')[3], "!") : 404 )
end

# HttpServer supports setting handlers for particular events
http.events["error"]  = ( client, err ) -> println( err )
http.events["listen"] = ( port )        -> println("Listening on $port...")

server = Server( http ) #create a server from your HttpHandler
run( server, 8000 ) #never returns
