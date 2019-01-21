class UsersController < ApplicationController

  # GET /
  # GET /users/:id/home
  def show
    @groups = @user.groups.where(archive: false)
    @assessments = Assessment.where(group_id: @groups).all
  end
end
