class StudentsController < ApplicationController
  #TODO: Sicherheitscheck!

  #GET /students
  def index
    render json: @user.students
  end

  #POST /students
  def create
    group = Group.find(params[:group])
    unless group.nil? || group.user_id != @user.id
      s = group.students.new(params.require(:student).permit(:name))
      if s.save
        render json: s
      else
        head 304
      end
    else
      head 304
    end
  end

  #PUT /students/:id
  def update
    s = Student.find(params[:id])
    unless s.nil? || !s.update_attributes(params.require(:student).permit(:name))
      render json: s
    else
      head 304
    end
  end

  #POST /students/:id
  def mass_update
    todo = JSON.parse(params[:students]) || []
    todo.each do |s|
      student = Student.find(s['id'])
      unless student.nil? || student.group.user.id != @user.id
        student.name = s['name']
        student.save
      end
    end
    head 200
  end

  #DEL /students/:id
  def destroy
    s = Student.find(params[:id])
    unless s.nil?
      s.destroy
    end
    head :ok
  end

end
