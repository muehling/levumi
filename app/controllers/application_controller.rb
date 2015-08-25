# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :check_login, except: [:welcome, :login]

  def login
    u = User.find_by_email(params[:loginemail])
    if u != nil
      if u.authenticate(params[:loginpassword])
        session[:user_id] = u.id
        @login = u
        redirect_to user_groups_path(u), notice: "Eingeloggt als #{u.email}"
      else
        redirect_to root_url, notice: "Benutzername oder Passwort falsch!"
      end
    else
      redirect_to root_url, notice: "Benutzername oder Passwort falsch!"
    end
  end

  def logout
    session[:user_id] = nil
    @login = nil
    redirect_to root_url
  end

  def welcome
    render 'welcome', :layout => 'bare'
  end

  private

  def check_login
    if session[:user_id].nil?
      redirect_to root_url, notice: "Bitte einloggen!"
     else
      @login = User.find(session[:user_id])
    end
  end
end
