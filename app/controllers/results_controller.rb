class ResultsController < ApplicationController
  before_action :set_student

  before_action :check_login, only: [:edit, :update]
  skip_before_action :set_login, only: [:edit, :update]

  #POST /students/:student_id/results
  def create
    if (params.has_key? :test_id)
      @test = Test.find(params[:test_id])
      a = Assessment.where(group_id: @student.group_id, test_id: @test.id).first       #Assessment aus student_id und test_id bestimmen
      #bestimmen des vorherigen Resultobjektes
      prior_result = Result.where(["student_id = ? and assessment_id = ?", @student.id, a]).order(:test_date).last
      prior_result = prior_result.nil? ? nil : prior_result.id
      @result = @student.results.create(assessment: a, prior_result_id: prior_result)
    end
    render 'edit', layout: 'blank'
  end

  #PUT /students/:student_id/results/:id
  def update
    @result = Result.find(params[:id])
    @result.results = JSON.parse(params[:results])
    @result.data = JSON.parse(params[:data])
    @result.test_date = DateTime.now
    @result.save
    head :ok
  end

  #GET /students/:student_id/results/:id/edit
  def edit
    @result = Result.find(params[:id])
    unless @result.nil?
      @test = @result.assessment.test
      render layout: 'blank'
    else
      head 403
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
