class StudentsController < ApplicationController
  before_action :set_group
  #Sicherheitscheck!
  #
  #GET /groups/:group_id/students
  def index
    render json: @user.students
  end

  #POST /groups/:group_id/students
  def create
    s = @group.students.new(params.require(:student).permit(:name))
    if s.save
      render json: s
    else
      head 304
    end
  end

  #PUT /groups/:group_id/students/:id
  def update
    s = Student.find(params[:id])
    unless s.nil? || !s.update_attributes(params.require(:student).permit(:name))
      render json: s
    else
      head 304
    end
  end

  #DEL /groups/:group_id/students/:id
  def destroy
    s = Student.find(params[:id])
    unless s.nil?
      s.destroy
    end
    head :ok
  end

  private
  def set_group
    @group = Group.find(params[:group_id])
  end
end
