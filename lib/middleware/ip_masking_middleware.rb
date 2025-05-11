require 'ipaddr'
module Middleware
  class IpMaskingMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      req = ActionDispatch::Request.new(env)

      remote_ip = req.get_header('action_dispatch.remote_ip'.freeze)
      addr = IPAddr.new(remote_ip.to_s)
      if addr.ipv4?
        t = addr.mask('255.255.0.0').to_s
      else
        t = addr.mask(48).to_s
      end

      req.remote_ip = t
      @app.call(req.env)
    end
  end
end
