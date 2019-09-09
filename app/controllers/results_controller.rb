class ResultsController < ApplicationController
  before_action :set_student

  before_action :check_login, only: [:create]
  skip_before_action :set_login, only: [:create]

  #POST /students/:student_id/results
  def create
    if params.has_key?(:test_id)           #Eigentlich "new" Action => Kein Objekt anlegen, Testseite rendern
      @test = Test.find(params[:test_id])
      unless @test.nil?
        @assessment = Assessment.where(group_id: @student.group_id, test_id: @test.id).pluck(:id).first       #Assessment aus student_id und test_id bestimmen
        @last_result = @student.results.where(assessment_id: @assessment).order(:test_week).last   #Letztes Ergebnis aus der Datenbank
        if @test.student_test         #Reicht das immer aus?
          @redirect = '/testen'
        else
          if params.has_key? :student
            @redirect = student_path(@student)
          else
            @redirect = group_assessment_path(@student.group, @test)
          end
        end
        render 'edit', layout: 'testing'
      end
    else      #Ergebnis eines Tests => Objekt anlegen
      @result = @student.results.build(assessment_id: params[:assessment_id])
      @result.views = JSON.parse(params[:views])
      @result.report = JSON.parse(params[:report])
      @result.data = JSON.parse(params[:data])
      @result.test_date = DateTime.now
      @result.save
      head :ok
    end
  end

  #DEL /students/:student_id/results/:id
  def destroy
    if @student.group.owner == @login
      @result = Result.find(params[:id])
      unless @result.nil? || @result.student != @student
        @result.destroy
        head :ok
      else
        head 403
      end
    else
      head 403
    end
  end

  private

  #Kind id aus Parametern holen und laden
  def set_student
    @student = Student.find(params[:student_id])
  end

  def check_login
    #Fall 1: User Login
    if session.has_key?(:user)
      if @student.group.owner.id == session[:user]
        return true
      end
    end
    #Fall 2: Schüler Login
    if session.has_key?(:student)
      if session[:student] == @student.id
        return true
      end
    end
    head 403
  end
end
