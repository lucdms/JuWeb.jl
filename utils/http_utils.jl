# Contents: Functions not specific to the current app.

#using HttpServer

################################################################################
### Generic handlers
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
