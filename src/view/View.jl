using Mustache

include("../config/Constants.jl") #constants

type View

	template_name
	template_rendered #bytes
		
	render::Function
	
	function View(template_name)
	
		this = new()
		
		this.template_name = template_name
		#this.template_rendered = open(readall, abspath("src","resources",this.template_name)) #carregar view
		this.template_rendered = open(readall, joinpath(RESOURCE_PATH,this.template_name)) #carregar view
		
		function render()
			println("Acessing View Layer! Interface with controllers. Rendering with Mustache...")
			return Mustache.render(this.template_rendered) #Mustache para renderizar a view
		end
		
		this.render=render
		
		return this
		
	end







end