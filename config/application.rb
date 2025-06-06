require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require_relative './initializers/custom_action_mailer_logger'
require_relative '../lib/middleware/ip_masking_middleware'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Levumi2
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.active_model.i18n_customize_full_message = true

    # allow svgs to served as svgs instead of octet-streams
    # see https://github.com/rails/rails/issues/34665#issuecomment-446628563
    config.active_storage.content_types_to_serve_as_binary -= ['image/svg+xml']

    config.action_mailer.logger =
      CustomActionMailerLogger.new(Rails.root.join("log/#{Rails.env}.log"))
    config.active_job.log_arguments = false

    config.middleware.insert_after ActionDispatch::RemoteIp, Middleware::IpMaskingMiddleware
  end
end
