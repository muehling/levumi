class UsersController < ApplicationController

  #GET /start
  #GET /users.id
  def show
    @groups = @user.groups.where(archive: false)
    @assessments = Assessment.where(group_id: @groups).all
  end

  #GET /users/edit.id
  def edit
  end

  #PUT /users.id
  def update
    unless @user.update_attributes(user_attributes)
      render 'edit'
    end
  end

  private
  def user_attributes
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
