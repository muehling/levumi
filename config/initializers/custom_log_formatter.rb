###################################
## Apparently, the stock ActionMailer ignores the filtered parameters defined in filter_parameter_logging.rb
## As it gets the generated :password as a parameter, it shows up in the log.
## This is a workaround to suppress logging of the initial passwords sent when registering an account.
##
## This log formatter is intended to be used by the action mailer and is applied in config/application.rb
###################################
class CustomLogFormatter < ActiveSupport::Logger::SimpleFormatter
  def call(severity, timestamp, progname, msg)
    if msg.include?('password')
      input = "[#{timestamp.strftime('%Y-%m-%d %H:%M:%S')}] #{severity} #{progname} #{msg}\n"
      input.gsub(/(\:password=>.*")/, ':password=>[CUSTOM FILTERED]')
    else
      super
    end
  end
end
