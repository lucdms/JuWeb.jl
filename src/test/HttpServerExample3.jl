################################################################################
#
# App: example_2_templates
#
# To run this app:
# - Type:
#     cd path/to/skeleton-webapp.jl/apps/example_2_templates
#     julia main_templates.jl
# - In your browser go to localhost:8000/home
#
################################################################################


# Include dependencies
using HttpServer    # Basic http/websockets server
using Mustache      # For populating html templates with data


# The app is just a function that takes in a Request and returns a Response.
# The response is initialised at the start of the function and modified later in the function.
# The request is never modified.
function app(req::Request)
    res = Response()
    if req.resource == "/home"
        tpl      = open(readall, "templates/home.html")                     # Retrieve template
        tpl_data = Dict("homepage_text" => "Hi, this is the home page.")    # Set data
        res.data = Mustache.render(tpl, tpl_data)                           # Return the template populated with data
    else
        res.status = 404
        res.data   = "Requested resource not found"
    end
    res
end


# Instantiate and run server
server = Server((req, res) -> app(req))    # Create Server instance with server.http.handle = anonymous function from (req, res) to res.
run(server, 8000)                          # This is a blocking function
