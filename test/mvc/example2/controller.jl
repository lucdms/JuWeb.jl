### Controllers
App.controller("posts") do
  using App.Controller

  function index()
    render(Post.title())
  end
end