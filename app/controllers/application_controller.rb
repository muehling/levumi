class ApplicationController < ActionController::Base
  before_action :set_login, except: [:start, :login]

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
      u.last_login = Time.now
      u.save
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
  def set_login
    if session.has_key?('user')
      @login = User.find(session[:user])
    else
      #redirect_to '/'
      @login = User.find(1) #Nur für Dev!
    end
  end

end
