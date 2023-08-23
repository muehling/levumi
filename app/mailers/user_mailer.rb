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
    @user = params[:user]
    @body = params[:body]
    subject =
      if params[:subject].nil?
        MailSubjects::LOGGABLE[:UNSPECIFIC_SUPPORT]
      else
        MailSubjects::LOGGABLE[:SPECIFIC_SUPPORT] + params[:subject]
      end

    subject_prefix = Rails.env.staging? ? 'STAGING ' : ''

    recipients =
      if Rails.env.development? || Rails.env.staging?
        'beckmann@leibniz-ipn.de'
      else
        %w[jana.jungjohann@ur.de beckmann@leibniz-ipn.de]
      end

    complete_subject = "#{subject_prefix.to_s}#{subject}"

    mail(bcc: recipients, from: @user.email, subject: complete_subject)
  end

  def new_share
    @recipient = params[:recipient]
    @share_key = params[:share_key]
    @is_anonymous = params[:is_anonymous]
    mail(to: @recipient.email, subject: MailSubjects::NON_LOGGABLE[:NEW_SHARE])
  end
end
