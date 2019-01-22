class UsersController < ApplicationController
  before_action :set_user, except: [:index, :new, :show, :create]

  #GET /start
  #GET /users/:id
  def show
    @groups = @login.groups.where(archive: false)
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
  def create
    @user = User.new(user_attributes)
    unless @user.save
      render 'edit'
    else
      @users = User.all  #Tabelle in der Benutzerverwaltung wird neu gerendert
    end
  end

  private
  def user_attributes
    if @login.has_capability?('user')
      params.require(:user).permit(:email, :password, :password_confirmation, :account_type)
    else
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end

  def set_user
    @user = User.find(params[:id])
    unless @user != nil || (@user.id != @login.id && !@login.has_capability?('user'))
      redirect_to '/'
    end
  end
end
