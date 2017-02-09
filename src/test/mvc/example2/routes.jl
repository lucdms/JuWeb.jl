### Routes



App.routes((
  # "post"           => [:create, :edit, :update, :destroy],
  # "post"           => :resource,
  "main#index"     => "/",
  "posts#index"    => "/posts"
))




#Post("/posts", (q,r)->(begin
#  println("params: ",q.params)
#  println("query: ",q.query)
#  println("body: ",q.body)
#  r.headers["Content-Type"]="text/plain"
#  global u="bye"
#  "I did something!"
#end))

