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

    mail(
      to: 'jbe@informatik.uni-kiel.de',
      from: @user.email,
      subject: 'Nachricht von Levumi - ' + params[:subject]
    )
  end
end
