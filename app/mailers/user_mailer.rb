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

    mail(
      bcc: %w[jana.jungjohann@ur.de beckmann@leibniz-ipn.de],
      from: @user.email,
      subject: subject
    )
  end
end
