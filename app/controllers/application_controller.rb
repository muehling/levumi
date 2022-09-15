class ApplicationController < ActionController::Base
  before_action :set_login, except: %i[start info login frontend login_frontend logout_frontend]
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
      @retry = true
      @no_script = true
      render :start
    end
  end

  #POST '/logout'
  def logout
    reset_session #Session löschen
    redirect_to '/'
  end

  #Zugang für Schülerinnen und Schüler

  #GET '/testen'
  def frontend
    @student = Student.find(session[:student]) if session.has_key?(:student)
    respond_to do |format|
      format.html do
        @no_script = true
        render :frontend, layout: 'minimal'
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
          render :frontend, layout: 'minimal'
        end
        format.json do
          render json: { tests: s.get_assessments, student: { id: s.id, login: s.login } }
        end
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

  #Login aus Session holen und ggf. Masquerading aktivieren
  def set_login
    if (session.has_key?('masquerading'))
      #Masquerading aktiv
      @login = User.find(session[:masquerading])
      @masquerade = true
    else
      if session.has_key?('user')
        #Session existiert
        @login = User.find(session[:user])
      else
        #TODO might be necessary to return an error here
        #Sonst: Startseite
        redirect_to '/'
      end
    end
  end

  def set_locale
    I18n.locale = :de
  end
end
