require 'period_opinionator'
require 'json'

class Greeter

  def call(env)
    req = Rack::Request.new(env)
    resp = Rack::Response.new

    if req.path == "/rack_app/correct" && req.post?
      resp['Content-type'] = "application/json"
      resp.write PeriodOpinionator.correct(req.params["text"]).to_json
    else
      resp.status = "404"
      resp.write "You made it to ruby land!  <br>But there was nothing hooked in to respond to the route requested."
    end

    resp
  end

end

run Greeter.new
