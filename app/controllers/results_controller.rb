class ResultsController < ApplicationController
  before_action :set_student

  before_action :check_login, only: [:edit, :update]
  skip_before_action :set_login, only: [:create, :edit, :update]

  #POST /students/:student_id/results
  def create
    @test = Test.find(params[:test_id])
    unless @test.nil?
      a = Assessment.where(group_id: @student.group_id, test_id: @test.id).first       #Assessment aus student_id und test_id bestimmen
      @result = @student.results.create(assessment: a)
      if @test.student_test         #Reicht das immer aus?
        @redirect = '/testen'
      else
        if params.has_key? :student
          @redirect = student_path(@result.student)
        else
          @redirect = group_assessment_path(@result.student.group, @test)
        end
      end
      render 'edit', layout: 'testing'
    end
  end

  #PUT /students/:student_id/results/:id
  def update
    @result = Result.find(params[:id])
    @result.views = JSON.parse(params[:views])
    @result.report = JSON.parse(params[:report])
    @result.data = JSON.parse(params[:data])
    @result.test_date = DateTime.now
    @result.save
    head :ok
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
