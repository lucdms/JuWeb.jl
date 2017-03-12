# Contents: Functions not specific to the current app.


################################################################################
### RESPONSE
################################################################################
function notfound!(req, res)
    # Modifies response to not found status
    res.status = 404
    res.data   = "<h1>Resource not found:</h1> <h3>$(req.resource[2:end])</h3> <h3>is not a valid resource.</h3>"
end


function file_response!(req, filename, res)
    # If filename exists populate response with file data, else set response to not found.
    res2 = HttpServer.FileResponse(filename)
    res.status   = res2.status
    res.headers  = res2.headers
    res.data     = res2.data
end


function serve_static_file(req::Request, res::Response)
  f = file_path(req.resource)
  res.status = 200
  res.headers = file_headers(f)
  res.data = open(read, f)
  return res
end


################################################################################
### RESPONSE FILE HEADERS
################################################################################

function file_headers(f)
  Dict{AbstractString, AbstractString}("Content-Type" => get(mimetypes, file_extension(f), "application/octet-stream"))
end

function file_extension(f) 
  ormatch(match(r"(?<=\.)[^\.\\/]*$", f), "")
end	

function ormatch(r::RegexMatch, x)
  return r.match
end

function ormatch(r::Void, x)
  return x
end




