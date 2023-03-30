###################################
## This logger prevents logging mail bodies which contain secrets.
## Currently, this concerns only the welcome email (which contains the initial password),
## and the mail sent when groups are shared (which contains the share key).
##
## These mails are determined by their subjects.
##
## The logger is applied in config/application.rb
###################################
class CustomActionMailerLogger < ActiveSupport::Logger
  def initialize(logdev, shift_age = 0, shift_size = 1_048_576)
    super
    self.formatter =
      proc do |severity, timestamp, progname, message|
        if message.include? MailSubjects::NON_LOGGABLE[:WELCOME]
          "[#{timestamp.strftime('%Y-%m-%d %H:%M:%S')}] #{severity} #{progname} Welcome mail: mail body filtered!\n"
        else
          "[#{timestamp.strftime('%Y-%m-%d %H:%M:%S')}] #{severity} #{message}\n"
        end
      end
  end
end
