class UsersController < ApplicationController
  before_action :set_user, except: [:index, :show, :create]
  skip_before_action :set_login, only: [:create]

  #GET /start
  #GET /users/:id
  def show
    @groups = @login.groups.where(archive: false)  #Daten für die "Home"-Ansicht laden. Alle aktuellen Assessments.
    @assessments = Assessment.where(group_id: @groups).all
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
  def create #Kann vom Backend oder von der Registrierung ausgelöst werden. Falls Registrierung, gibt es keinen Login.
    @user = User.new(user_attributes)
    if @login
      unless @user.save
        render 'edit'
      else
        @users = User.all  #Tabelle in der Benutzerverwaltung wird neu gerendert
        render 'create_backend'
      end
    else
      pw = @user.generate_password
      if @user.save
        #Mail senden...
        render 'create_register'
      else
        render 'new'
      end
    end
  end

  private

  def user_attributes
    params.require(:user).permit(:email, :password, :password_confirmation, :account_type)
  end

  #Nutzernummer aus Parametern holen und User laden
  def set_user
    @user = User.find(params[:id])
    unless @user != nil || (@user.id != @login.id && !@login.has_capability?('user')) #Entweder es ist der eigene Nutzer oder die entsprechende Berechtigung ist vorhanden
      redirect_to '/'
    end
  end
end
