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

#module IpAnonymizer
#  def self.mask_ip(ip)
#    addr = IPAddr.new(ip.to_s)
#    if addr.ipv4?
#      # set last octet to 0
#      addr.mask(24).to_s
#    else
#      # set last 80 bits to zeros
#      addr.mask(48).to_s
#    end
#  end
#end
#
#module IpAnonymizer
#  class MaskIp
#    def initialize(app)
#      @app = app
#    end
#
#    def call(env)
#      req = ActionDispatch::Request.new(env)
#
#      # get header directly to preserve ActionDispatch::RemoteIp lazy loading
#      req.remote_ip = GetIp.new(req.get_header('action_dispatch.remote_ip'.freeze))
#      @app.call(req.env)
#    end
#
#    class GetIp
#      def initialize(remote_ip)
#        @remote_ip = remote_ip
#      end
#
#      def to_s
#        @ip ||= IpAnonymizer.mask_ip(@remote_ip)
#      end
#    end
#  end
#end
#
