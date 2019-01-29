class StudentsController < ApplicationController

  #GET /students
  def index
    render json: @login.students
  end

  #POST /students
  def create    #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
    group = Group.find(params[:group])
    unless group.nil? || group.user_id != @login.id
      s = group.students.new(student_attributes)
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
  def update   #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
    s = Student.find(params[:id])
    unless s.nil? || s.group.user.id != @login.id || !s.update_attributes(student_attributes)
      render json: s
    else
      head 304
    end
  end

  #POST /students/:id
  def mass_update   #Neucodierung aller Namen nach Passwort-Änderung. Rückmeldung durch 200 an fetch-API
    todo = JSON.parse(params[:students]) || [] #Gesendet werden (key, value)-Paare der Student-Objekte (id, name).
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
    head :ok #200 als Rückmeldung an Vue-Component
  end

  private

  def student_attributes
    params.require(:student).permit(:name, :gender, :birthmonth, :sen, :migration)
  end

end
