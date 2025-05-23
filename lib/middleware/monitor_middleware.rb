module Middleware
  class MonitorMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if !env['HTTP_X_REQUEST_START'].nil?
        request_start_header = env['HTTP_X_REQUEST_START']
        network_time = env['puma.request_body_wait'].to_i
        req = "#{env['REQUEST_METHOD']} #{env['REQUEST_URI']}"
        value = request_start_header.gsub(/[^0-9.]/, '').to_f

        now = Time.now
        queue_time = ((now - Time.at(value)) * 1000).to_i
        queue_time -= network_time

        Rails
          .logger.info "######################## queue_time=#{queue_time}ms network_time=#{network_time}ms #{req}"
      else
        queue_time = 'unknown '
        req = "#{env['REQUEST_METHOD']} #{env['REQUEST_URI']}"
        Rails
          .logger.info "######################## queue_time=#{queue_time}ms network_time=#{network_time}ms #{req}"
      end
      @app.call(env)
    end
  end
end
