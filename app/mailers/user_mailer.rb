class UserMailer < ApplicationMailer

  def welcome
    @user = params[:user]
    @password = params[:password]
    mail(to: @user.email, subject: 'Herlich Willkommen bei Levumi!')
  end
end
