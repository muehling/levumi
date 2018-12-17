class UsersController < ApplicationController

  # GET /
  # GET /users/:id/home
  def home
    @groups = @user.groups.all
    @assessments = Assessment.where(group_id: @groups).all
    @tests = Test.all
  end
end
