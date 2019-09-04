class ApplicationController < ActionController::Base
  before_action :set_login, except: [:start, :login, :frontend, :login_frontend]
  before_action :set_locale

  #Normaler Zugang

  #GET '/'
  def start
    reset_session #Alte Daten ggf. entfernen
    respond_to do |format|
      format.html {
        render :start
      }
    end
  end

  #POST '/login'
  def login
    u = User.find_by_email(params[:email])
    if !u.nil? && u.authenticate(params[:password])
      reset_session           #Alte Daten ggf. entfernen
      session[:user] = u.id
      u.last_login = Time.now
      u.save
      redirect_to '/start'
    else
      @retry = true
      render :start
    end
  end

  #POST '/logout'
  def logout
    reset_session    #Session löschen
    redirect_to '/'
  end


  #Zugang für Schülerinnen und Schüler

  #GET '/testen'
  def frontend
    if session.has_key?(:student)
      @student = Student.find(session[:student])
    end
    respond_to do |format|
      format.html {
        render :frontend, layout: 'minimal'
      }
    end
  end

  #POST '/testen_login'
  def login_frontend
    s = Student.find_by_login(params[:login].upcase)
    unless s.nil?
      session[:student] = s.id
      render json: {tests: s.get_assessments, student: {id: s.id, login: s.login}}
    else
      head 403
    end
  end

  #POST '/testen_logout'
  def logout_frontend
    session.delete(:student)
    head 200
  end

  #Masquerading

  #GET '/login'
  def start_masquerade
    u = User.find(params[:user])  #User wird als Parameter übergeben
    if !u.nil? && @login.has_capability?('user')
      session[:masquerading] = u.id
      redirect_to '/start'
    else
      redirect_to '/'
    end
  end

  #GET '/logout'
  def end_masquerade
    if (session.has_key?(:masquerading))     #Nur Key aus Session löschen, damit alter Login erhalten bleibt.
      session.delete(:masquerading)
    end
    redirect_to users_path    #Zurück zum Ausgangspunkt (Nutzer muss Berechtigung user sowieso haben)
  end

  private

  #Login aus Session holen und ggf. Masquerading aktivieren
  def set_login
    if (session.has_key?('masquerading'))       #Masquerading aktiv
      @login = User.find(session[:masquerading])
      @masquerade = true
    else
      if session.has_key?('user')               #Session existiert
        @login = User.find(session[:user])
        if (@login.tc_accepted.nil? || @login.intro_state < 4)  #Registrierung noch nicht vollständig abgeschlossen oder neue Nutzungsbedingungen
          redirect_to '/willkommen'
        end
      else                                      #Sonst: Startseite
        redirect_to '/'
      end
    end
  end

  def set_locale
    I18n.locale = :de
  end

end
