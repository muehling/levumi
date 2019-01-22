class ApplicationController < ActionController::Base
  before_action :set_user, except: [:start, :login]

  #GET '/'
  def start
    reset_session
    respond_to do |format|
      format.html {
        @retry = false
        render file: 'layouts/landing', layout: false
      }
    end
  end

  #POST '/login'
  def login
    u = User.find_by_email(params[:email])
    if !u.nil? && u.authenticate(params[:password])
      reset_session
      session[:user] = u.id
      redirect_to '/start'
    else
      @retry = true
      render file: 'layouts/landing', layout: false
    end
  end

  #POST '/logout'
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
