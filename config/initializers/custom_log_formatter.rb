###################################
## Apparently, the stock ActionMailer ignores the filtered parameters defined in filter_parameter_logging.rb
## As it gets the generated :password as a parameter, it shows up in the log.
## This is a workaround to suppress logging of the initial passwords sent when registering an account.
##
## This log formatter is intended to be used by the action mailer and is applied in config/application.rb
###################################
class CustomLogFormatter < ActiveSupport::Logger::SimpleFormatter
  def call(severity, timestamp, progname, msg)
    msg = filter_parameters(msg)
    super
  end

  private

  def filter_parameters(message)
    filter_parameters = Rails.application.config.filter_parameters
    return message unless filter_parameters.present?

    filter_parameters.each do |param|
      message.gsub(/#{param}=>"[^"]*"/, "#{param} => [custom filtered]")
    end
    return message
  end
end
