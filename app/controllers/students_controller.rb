class StudentsController < ApplicationController

  def index
    @groups = @user.groups.all
  end
end
