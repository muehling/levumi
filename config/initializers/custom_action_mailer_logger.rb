###################################
## This logger prevents logging mail bodies which contain secrets.
##
## The logger is applied in config/application.rb to affect all environments.
###################################
class CustomActionMailerLogger < ActiveSupport::Logger
  def initialize(logdev, shift_age = 0, shift_size = 1_048_576)
    super
    self.formatter =
      proc do |severity, timestamp, progname, message|
        MailSubjects::NON_LOGGABLE.reduce(message) do |acc, value|
          if message.present? && (message.include? value[1])
            "[#{timestamp.strftime('%Y-%m-%d %H:%M:%S')}] #{severity} #{progname} Sent mail with subject NON_LOGGABLE::#{value[0]}: Mail body filtered!\n"
          else
            acc
          end
        end
      end
  end
end
