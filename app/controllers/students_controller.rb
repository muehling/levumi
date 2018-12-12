class StudentsController < ApplicationController

  def index
    @groups = User.find(1).groups.all
    @students = Student.where(group: @groups).all
  end
end
