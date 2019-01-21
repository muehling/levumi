class ApplicationController < ActionController::Base
  before_action :set_user, except: [:start, :login]

  def start
    reset_session
    respond_to do |format|
      format.html {
        render file: 'layouts/landing', layout: false
      }
    end
  end

  def login
    u = User.find_by_email(params[:email])
    if !u.nil? && u.authenticate(params[:password])
      reset_session
      session[:user] = u.id
      redirect_to users_path(u)
    else
      render file: 'layouts/landing', layout: false
    end
  end

  def logout
    session[:user] = nil
    redirect_to '/'
  end

  private
  #Auto Log-In zum Entwickeln
  def set_user
    if session.has_key?('user')
      @user = User.find(session[:user])
    else
      #redirect_to '/'
      @user = User.find(1) #Nur für Dev!
    end
  end

end
