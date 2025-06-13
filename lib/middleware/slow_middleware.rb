module Middleware
  class SlowMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      request_path = env['PATH_INFO']
      sleep 3 if request_path.match?(/\.(webp|mp3|png|jpg|svg|woff2?)$/)
      @app.call(env)
    end
  end
end
