class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_token

  before_action :set_login,
                except: %i[
                  info
                  login
                  frontend
                  login_frontend
                  logout_frontend
                  redirect_to_registration_error
                ]
  before_action :check_maintenance, except: %i[login]
  before_action :set_locale
  before_action :set_timestamp

  #Normaler Zugang

  #GET '/'
  def start
    headers['Cache-Control'] = 'no-store, must-revalidate'
    respond_to do |format|
      format.html do
        @no_script = true #verhindert Einbinden von _scripts.html.erb => Ansonsten Endlos-Redirect wegen fehlendem session Eintrag.
        render :start, layout: 'startpage'
      end
    end
  end

  #GET '/info'
  def info
    respond_to do |format|
      format.html do
        @no_script = true #verhindert Einbinden von _scripts.html.erb => Ansonsten Endlos-Redirect wegen fehlendem session Eintrag.
        render :info
      end
    end
  end

  #POST '/login'
  def login
    u = User.find_by_email(params[:email])
    if !u.nil? && u.authenticate(params[:password])
      session[:user] = u.id
      u.last_login = Time.now
      u.save
      head :ok
    else
      if ENV['MAINTENANCE'] == 'true'
        @retry = true
        render :maintenance
      else
        render json: {
                 message: 'Benutzername und Passwort stimmen nicht überein!'
               },
               status: :forbidden
      end
    end
  end

  def renew_login
    u = User.find_by_email(params[:email])
    if !u.nil? && u.authenticate(params[:password])
      session[:user] = u.id
      u.last_login = Time.now
      u.save
      head :ok
    else
      render json: {
               message: 'application_controller::renew_login: user not found or invalid credentials'
             },
             status: :forbidden
    end
  end

  def redirect_to_registration_error
    render :registration_error, layout: 'minimal'
  end

  #POST '/logout'
  def logout
    reset_session #Session löschen
    head :ok
  end

  #Zugang für Schülerinnen und Schüler

  #GET '/testen'
  def frontend
    headers['Cache-Control'] = 'no-store, must-revalidate'
    @student = Student.find(session[:student]) if session.has_key?(:student)
    respond_to do |format|
      format.html do
        @no_script = true
        render :frontend, layout: 'test_select'
      end
    end
  end

  #POST '/testen_login'
  def login_frontend
    headers['Cache-Control'] = 'no-store, must-revalidate'
    if !params[:login].present?
      render json: { message: 'login_frontend: no object sent' }, status: :forbidden and return
    end
    if params[:login].empty?
      render json: { message: 'login_frontend: object empty' }, status: :forbidden and return
    end

    s = Student.find_by_login(params[:login].upcase)
    unless s.nil?
      session[:student] = s.id
      respond_to do |format|
        format.html do
          @student = s
          render :frontend, layout: 'test_select'
        end
        format.json { render json: { student: s, tests: s.get_assessments }, status: :ok }
      end
    else
      render json: { message: 'login_frontend: code not found' }, status: :forbidden
    end
  end

  #POST '/testen_logout'
  def logout_frontend
    session.delete(:student)
    respond_to do |format|
      format.html { redirect_to '/testen' }
      format.json { head :ok }
    end
  end

  #Masquerading

  #GET '/login'
  def start_masquerade
    u = User.find(params[:user]) #User wird als Parameter übergeben
    if !u.nil? && @login.has_capability?('user')
      session[:masquerading] = u.id
      redirect_to '/diagnostik'
    else
      redirect_to '/'
    end
  end

  #GET '/logout'
  def end_masquerade
    if (session.has_key?(:masquerading))
      #Nur Key aus Session löschen, damit alter Login erhalten bleibt.
      session.delete(:masquerading)
    end

    head :ok
  end

  private

  def handle_invalid_token
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json do
        render json: {
                 message: 'application_controller::handle_invalid_token: invalid token'
               },
               status: :unauthorized
      end
    end
  end

  def check_maintenance
    if ENV['MAINTENANCE'] == 'true'
      if !session.has_key?('user')
        render :maintenance, layout: false
      elsif session.has_key?('masquerading')
        # no redirect when using masquerade in maintenance module
      else
        user = User.find_by_id(session[:user])
        if !user || !user.has_capability?('admin')
          reset_session
          redirect_to root_path
        end
        @login = user
      end
    end
  end

  #Login aus Session holen und ggf. Masquerading aktivieren
  def set_login
    if (session.has_key?('masquerading'))
      #Masquerading aktiv
      @login = User.find(session[:masquerading])
      @masquerade = true
    elsif session.has_key?('user')
      #Session existiert
      user = User.find_by_id(session[:user])
      if !user
        reset_session
        redirect_to root_path
      end
      @login = user
    else
      # return 401 for unauthorized api calls
      head :unauthorized and return if request.format.json?

      # only redirect to frontpage if not already there to avoid endless cycle
      redirect_to root_path if request.fullpath != '/' && request.fullpath != '/?logout=true'
    end
  end

  def set_locale
    I18n.locale = :de
  end

  def set_timestamp
    @render_timestamp = Time.now
  end
end
