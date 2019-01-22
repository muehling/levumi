class StudentsController < ApplicationController

  #GET /students
  def index
    render json: @login.students
  end

  #POST /students
  def create
    group = Group.find(params[:group])
    unless group.nil? || group.user_id != @login.id
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
    unless s.nil? || s.group.user.id != @login.id || !s.update_attributes(params.require(:student).permit(:name))
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
      unless student.nil? || student.group.user.id != @login.id
        student.name = s['name']
        student.save
      end
    end
    head 200
  end

  #DEL /students/:id
  def destroy
    s = Student.find(params[:id])
    unless s.nil? || s.group.user.id != @login.id
      s.destroy
    end
    head :ok
  end

end
