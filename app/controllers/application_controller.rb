# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :check_login, except: [:welcome, :login]
  before_filter :check_accept, except: [:welcome, :login, :accept, :static, :logout]

  def login
    u = User.find_by_email(params[:email])
    if u != nil
      if u.authenticate(params[:password])
        session[:user_id] = u.id
        @login = u
        news = News.new_items(u)
        u.last_login = Time.now
        u.save
        redirect_to user_groups_path(u), notice: news.empty? ? "Eingeloggt als #{u.email}" : news.join("<br/><br/>")
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
    if params.has_key?(:page)
      render params[:page], :layout => 'bare'
    else
      render 'welcome', :layout => 'bare'
    end
  end

  def accept
    @login.tcaccept = DateTime.now
    @login.save
    redirect_to user_groups_path(@login), notice: "Viel Spaß bei der Benutzung von LeVuMi!"
  end

  def static
    render params[:page]
  end

  def export
    unless @login.hasCapability?("export")
      redirect_to root_url
    end
    @tests = Test.all
    @users = User.all
  end

  private

  def check_login
    if session[:user_id].nil? && session[:student_id].nil?
      redirect_to root_url, notice: "Bitte einloggen!"
    elsif session[:user_id].nil?
      @login = Student.find(session[:student_id])
      #redirect_to root_url, notice: @login.id
     else
      @login = User.find(session[:user_id])
    end
  end

  def check_accept
    if @login.tcaccept.nil?
      render 'accept'
    end
  end

end
