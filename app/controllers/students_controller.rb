class StudentsController < ApplicationController

  #GET /students
  def index
    render json: @login.students
  end

  #POST /students
  def create    #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
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

  #GET /students/:id.js
  #GET /students/:id.html
  def show
    s = Student.find(params[:id])
    respond_to do |format|
      format.js {   #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
        unless s.nil?
          render json: s.get_assessments
        else
          head 304
        end
      }
      format.html {  #Deep-Link in das Klassenbuch
        unless s.nil?
          #Daten für Klassenbuch laden
          @data = {
              'groups': [Group.new] + @login.get_classbook_info,
              'single': @login.account_type == 2,
              'selected': s
          }
          render 'groups/index'
        end
      }
    end
  end

  #PUT /students/:id
  def update   #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
    s = Student.find(params[:id])
    unless s.nil? || s.group.read_only(@login) || !s.update_attributes(student_attributes)
      render json: s
    else
      head 304
    end
  end

  #DEL /students/:id
  def destroy
    s = Student.find(params[:id])
    unless s.nil? || s.group.read_only(@login)
      s.destroy
    end
    head :ok #200 als Rückmeldung an Vue-Component
  end

  private

  def student_attributes
    params.require(:student).permit(:name, :gender, :birthmonth, :sen, :migration)
  end

end
