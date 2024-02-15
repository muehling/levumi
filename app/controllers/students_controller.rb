class StudentsController < ApplicationController
  before_action :set_student, except: %i[create]

  #GET /students
  def index
    render json: @login.students
  end

  #POST /students
  def create #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
    group = Group.find(params[:group])
    unless group.nil? || group.read_only(@login)
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

  def show
    respond_to do |format|
      format.json do #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung => Schüleransicht
        unless @student.nil?
          render json: @student.get_assessments
        else
          head 304
        end
      end
      format.html do #Anzeige als eigene Seite => Lehrkraft-Ansicht
        render :show, layout: 'minimal' unless @student.nil?
      end
    end
  end

  #PUT /students/:id
  def update #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
    unless @student.nil? || @student.group.read_only(@login) || !@student.update(student_attributes)
      render json: @student
    else
      head 304
    end
  end

  #DEL /students/:id
  def destroy
    @student.destroy unless @student.nil? || @student.group.read_only(@login)
    head :ok #200 als Rückmeldung an Vue-Component
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_attributes
    params
      .require(:student)
      .permit(:name, :gender, :birthmonth, :sen, :tags, settings: %i[font_family font_size])
  end
end
