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

  #GET '/login'
  def start_masquerade
    u = User.find(params[:user])
    if !u.nil? && @login.has_capability?('user')
      session[:masquerading] = u.id
      redirect_to '/start'
    else
      redirect_to '/'
    end
  end

  #GET '/logout'
  def end_masquerade
    if (session.has_key?(:masquerading))
      session.delete(:masquerading)
    end
    redirect_to users_path
  end

  private
  #Login aus Session holen und ggf. Masquerading aktivieren
  def set_login
    if (session.has_key?('masquerading'))
      @login = User.find(session[:masquerading])
      @masquerade = true
    else
      if session.has_key?('user')
        @login = User.find(session[:user])
      else
        redirect_to '/'
      end
    end
  end

end
