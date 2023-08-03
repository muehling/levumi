class ApplicationController < ActionController::Base
  before_action :set_login, except: %i[info login frontend login_frontend logout_frontend]
  before_action :check_maintenance, except: %i[login]
  before_action :set_locale

  #Normaler Zugang

  #GET '/'
  def start
    respond_to do |format|
      format.html do
        @no_script = true #verhindert Einbinden von _scripts.html.erb => Ansonsten Endlos-Redirect wegen fehlendem session Eintrag.
        render :start
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
      redirect_to '/start'
    else
      if ENV['MAINTENANCE'] == 'true'
        @retry = true
        render :maintenance
      else
        @retry = true
        @no_script = true
        render :start
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
      head :not_found
    end
  end

  #POST '/logout'
  def logout
    reset_session #Session löschen
    redirect_to '/?logout=true' # Query param tells the frontend to delete the sessionStorage entry
  end

  #Zugang für Schülerinnen und Schüler

  #GET '/testen'
  def frontend
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
    s = Student.find_by_login(params[:login].upcase)
    unless s.nil?
      session[:student] = s.id
      respond_to do |format|
        format.html do
          @student = s
          @no_script = true
          render :frontend, layout: 'test_select'
        end
        format.json { head :ok }
      end
    else
      head 403
    end
  end

  #POST '/testen_logout'
  def logout_frontend
    session.delete(:student)
    respond_to do |format|
      format.html { redirect_to '/testen' }
      format.js { head 200 }
    end
  end

  #Masquerading

  #GET '/login'
  def start_masquerade
    u = User.find(params[:user]) #User wird als Parameter übergeben
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
      #Nur Key aus Session löschen, damit alter Login erhalten bleibt.
      session.delete(:masquerading)
    end

    head :ok
  end

  private

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
      #TODO might be necessary to return an error here for api calls
      # only redirect to frontpage if not already there to avoid endless cycle
      redirect_to root_path if request.fullpath != '/' && request.fullpath != '/?logout=true'
    end
  end

  def set_locale
    I18n.locale = :de
  end
end
