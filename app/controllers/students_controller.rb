class StudentsController < ApplicationController

  def index
    @groups = @user.groups.all
    @group = @user.groups.new
  end
end
