class SomeMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['PATH_INFO'] == "/mware_path"
      ['200', {'Content-Type' => "text/html"}, ["the middleware kicked in, did something and discontinued the chain... app not hit!"]]
    else
      @app.call(env)
    end
  end
end
