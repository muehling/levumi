# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :check_login

  def login
    u = User.find_by_email(params[:email])
    if u != nil
      if u.authenticate(params[:password])
        session[:user_id] = u.id
        @login = u
        redirect_to user_groups_path(u), notice: "Eingeloggt als #{u.email}"
      else
        redirect_to '/', notice: "Benutzername oder Passwort falsch!"
      end
    else
      redirect_to '/', notice: "Benutzername oder Passwort falsch!"
    end
  end

  def logout
    session[:user_id] = nil
    @login = nil
    redirect_to '/'
  end

  private

  def check_login
    if session[:user_id].nil?
      @login = User.find(1) # Auto-Login!
     else
      @login = User.find(session[:user_id])
    end
  end
end
