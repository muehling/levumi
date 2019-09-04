class UsersController < ApplicationController
  before_action :set_user, except: [:index, :show, :create, :register, :recover]

  skip_before_action :set_login, only: [:create, :register, :recover]

  #GET /start
  #GET /users/:id
  def show
    #Daten für die "Home"-Ansicht laden.
    @groups = @login.groups.where(archive: false).order(id: :desc).map {|g| g.as_hash(@login)}
  end

  #GET /users/edit/:id
  def edit
  end

  #PUT /users/:id
  def update
    if params.has_key?('text') && @login.id == @user.id       #Send mail to all users
      if params.has_key?('teacher')
        User.where(account_type: 0).each do |u|
          UserMailer.with(user: @user, body: params['text']).notify.deliver_later
        end
      end
      if params.has_key?('researcher')
        User.where(account_type: 1).each do |u|
          UserMailer.with(user: @user, body: params['text']).notify.deliver_later
        end
      end
      if params.has_key?('private')
        User.where(account_type: 2).each do |u|
          UserMailer.with(user: @user, body: params['text']).notify.deliver_later
        end
      end
      render js: "alert('Nachricht wurde verschickt!')"
    else                        # "Normales" Update
      if @login.has_security? && user_attributes.has_key?(:password) && !user_attributes.has_key?(:security_digest)  #Leere Parameter werden entfernt
        @user.errors.add(:security_digest)
        render 'edit'
      elsif !@user.update_attributes(user_attributes)
        render 'edit'
      else
        if (@login.id == @user.id) #Eigenes Update, ggf. keys Recodieren
          if (params.has_key?(:user) && params[:user].has_key?(:keys) && !params[:user][:keys].blank?)
            todo = JSON.parse(params[:user][:keys]) || [] #Gesendet werden (key, value)-Paare der keys für GroupAccess-Objekte.
            todo.each do |k, v|
              ga = GroupShare.where(user: @login, group_id: k).first
              unless ga.nil? || ga.key.nil? || ga.key.blank?
                ga.key = v
                ga.save
              end
            end
          end
        else
          @users = User.all   #Update für anderen Nutzer aus der Benutzerverwaltung => Tabelle wird neu gerendert
        end
      end
    end
  end

  #GET /users
  def index
    @users = User.all
  end

  #DEL /users/:id
  def destroy
    if @user.id != @login.id  #Nicht seinen eigenen Account löschen...
      @user.destroy
    end
    @users = User.all #Tabelle in der Benutzerverwaltung wird neu gerendert
  end

  #POST /users
  def create #Kann vom Backend oder von der Registrierung ausgelöst werden. Falls Registrierung, gibt es keinen Login in der Session.
    @user = User.new(user_attributes)
    pw = @user.generate_password
    if (session.has_key?('user'))          #TODO: Ggf. Masquerading prüfen, kann aber regulär nicht passieren...
      @login = User.find(session[:user])   #Login muss gesetzt werden, da before_action für create ausgelassen wird.
      unless @user.save
        render 'edit'
      else
        @users = User.all                  #Benötigt für Tabelle in der Benutzerverwaltung
        render 'create_backend'
      end
    else                                   #Anfrage kommt von der Registrierungsseite
      if @user.save
        UserMailer.with(user: @user, password: pw).welcome.deliver_later
        render 'create_register'
      else
        render 'new'
      end
    end
  end

  #GET /willkommen
  #POST /willkommen
  def register
    @user = User.find(session[:user])               #Login nicht gesetzt, da before action nicht ausgeführt.
    redirect_to '/' if @user.nil?

    #GET Anfrage standardmäßig nur am Anfang und Ende, oder bei Unterbrechung des Prozesses
    if request.get?
      case @user.intro_state
      when 0 #Anfang des Intros
        render 'users/intro/terms_and_conditions', layout: 'minimal' and return
      when 1..2
        render 'users/intro/forms', layout: 'minimal' and return
      when 3 #Intro neu starten
        @login = @user
        render 'users/intro/help' and return
      end
    end

    if request.patch?
      if params.has_key?('tc_accepted')
        @user.tc_accepted = Time.now
        @user.intro_state = 1 if @user.intro_state == 0 #Abfrage für spätere TC-Änderungen, dort kein Ändern von intro_state mehr!
        @user.save
        if @user.intro_state == 1
          render 'users/intro/forms', layout: 'minimal' and return
        else
          redirect_to @user
        end
      else
        case @user.intro_state
        when 0 #TC Accept hat noch nicht stattgefunden!
          render 'users/intro/terms_and_conditions', layout: 'minimal' and return
        when 1 #TC Accept => Passwort/Sicherheitsfrage wird angezeigt
          if @user.update_attributes(user_attributes)
            @user.intro_state = 2
            @user.save
          end
          render 'users/intro/forms', layout: 'minimal' and return #Hier entweder zurück wegen Fehler, oder weiter
        when 2 #TC Accept + erste Form => Zweite Form wird geschickt
          @user.update_attributes(user_attributes) if params.has_key?(:user)  #Unkritische Attribute, deswegen kein Fehlercheck, if ist nötig für Privat-Accounts, dort wird nichts mitgeschickt (require schlägt dann fehl)
          @user.create_demo(params[:key], params[:auth_token])
          @user.intro_state = 3
          @user.save
          @login = @user
          render 'users/intro/help' and return
        when 3
          @user.intro_state = 4
          @user.save
          redirect_to '/start'
        else
          if params.has_key?(:classbook)
            @user.intro_state += 10
            @user.save
            head 200 and return
          end
        end
      end
    end
  end

  #GET /passwort
  #POST /passwort
  def recover
    if request.post?
      @user = User.find_by_email(params[:email])
    else
      render 'recover', layout: 'minimal'
    end
  end

  private

  def user_attributes
    temp = params.require(:user).permit(:email, :password, :password_confirmation, :security_digest, :account_type, :state, :institution, :town, :school_type, :focus).reject{|_, v| v.blank?}
    if temp.has_key?(:password) && !temp.has_key?(:password_confirmation)
      temp[:password_confirmation] = ''
    end
    temp
  end

  #Nutzernummer aus Parametern holen und User laden
  def set_user
    @user = User.find(params[:id])
    unless @user != nil || (@user.id != @login.id && !@login.has_capability?('user')) #Entweder es ist der eigene Nutzer oder die entsprechende Berechtigung ist vorhanden
      redirect_to '/'
    end
  end
end
