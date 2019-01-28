class UsersController < ApplicationController
  before_action :set_user, except: [:index, :show, :create, :register]

  skip_before_action :set_login, only: [:create, :register]

  #GET /start
  #GET /users/:id
  def show
    @groups = @login.groups.where(archive: false)  #Daten für die "Home"-Ansicht laden. Alle aktuellen Assessments.
    @assessments = Assessment.where(group_id: @groups).all
    if @login.is_new
      @login.is_new = false
      @login.save
      render 'intro'
    else
      render 'show'
    end
  end

  #GET /users/edit/:id
  def edit
  end

  #PUT /users/:id
  def update
    unless @user.update_attributes(user_attributes)
      render 'edit'
    else
      if (@login.id != @user.id)  #Update für anderen Nutzer aus der Benutzerverwaltung => Tabelle wird neu gerendert
        @users = User.all
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
        #Mail senden...
        render 'create_register'
      else
        render 'new'
      end
    end
  end

  def register
    @user = User.find(session[:user])
    if request.post?
      @user.tc_accepted = Time.now
      @user.save
      redirect_to '/start'
    else
      render 'register', layout: 'minimal'
    end
  end

  private

  def user_attributes
    params.require(:user).permit(:email, :password, :password_confirmation, :security_digest, :account_type, :state, :institution, :town, :school_type, :focus)
  end

  #Nutzernummer aus Parametern holen und User laden
  def set_user
    @user = User.find(params[:id])
    unless @user != nil || (@user.id != @login.id && !@login.has_capability?('user')) #Entweder es ist der eigene Nutzer oder die entsprechende Berechtigung ist vorhanden
      redirect_to '/'
    end
  end
end
