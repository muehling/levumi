class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    @password = params[:password]
    mail(to: @user.email, subject: MailSubjects::NON_LOGGABLE[:WELCOME])
  end

  def notify
    @user = params[:user]
    @body = params[:body]
    mail(to: @user.email, subject: MailSubjects::LOGGABLE[:NEWS])
  end

  def support
    @email = params[:email]
    @body = params[:body]
    subject =
      if params[:subject].nil?
        MailSubjects::LOGGABLE[:UNSPECIFIC_SUPPORT]
      else
        MailSubjects::LOGGABLE[:SPECIFIC_SUPPORT] + params[:subject]
      end

    subject_prefix = Rails.env.staging? ? 'STAGING ' : ''

    recipients =
      if Rails.env.development? || Rails.env.staging? || !params[:server_error].nil?
        'beckmann@leibniz-ipn.de'
      else
        params[:support_addresses]
      end

    complete_subject = "#{subject_prefix.to_s}#{subject}"

    mail(bcc: recipients, from: 'noreply@levumi.de', subject: complete_subject)
  end

  def new_share
    @sender = params[:sender]
    @group_label = params[:group_label]
    @recipient = params[:recipient]
    @share_key = params[:share_key]
    @is_anonymous = params[:is_anonymous]
    mail(to: @recipient.email, subject: MailSubjects::NON_LOGGABLE[:NEW_SHARE])
  end

  def test_update
    @updater = params[:updater]
    @shorthand = params[:shorthand]
    recipients = Rails.env.production? ? %w[beckmann@leibniz-ipn.de] : 'beckmann@leibniz-ipn.de'
    mail(to: recipients, subject: "#{@updater} hat #{@shorthand} hochgeladen!")
  end

  def password_reset
    puts 'ich war hier ##############################################################'
    @user = params[:user]
    mail(to: @user.email, subject: MailSubjects::NON_LOGGABLE[:PASSWORD_RESET])
  end
end
