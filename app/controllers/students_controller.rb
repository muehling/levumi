class StudentsController < ApplicationController

  def index
    render json: @user.students
  end
end
