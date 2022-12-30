class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    @password = params[:password]
    mail(to: @user.email, subject: 'Herzlich Willkommen bei Levumi!')
  end

  def notify
    @user = params[:user]
    @body = params[:body]
    mail(to: @user.email, subject: 'Neuigkeiten von Levumi')
  end

  def support
    @user = params[:user]
    @body = params[:body]
    subject =
      if params[:subject].nil?
        'Nachricht vom Levumi-Kontaktformular'
      else
        'Nachricht von Levumi - ' + params[:subject]
      end

    mail(
      bcc: %w[jana.jungjohann@ur.de beckmann@leibniz-ipn.de],
      from: @user.email,
      subject: subject
    )
  end
end
