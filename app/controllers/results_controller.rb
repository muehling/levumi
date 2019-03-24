class ResultsController < ApplicationController
  before_action :set_student, except: [:edit]

  before_action :check_login, only: [:edit]
  skip_before_action :set_login, only: [:edit]

  #POST /students/:student_id/results
  def create
    if (params.has_key? :test_id)
      @test = Test.find(params[:test_id])
      a = Assessment.where(group_id: @student.group_id, test_id: @test.id).first       #Assessment aus student_id und test_id bestimmen

      #TODO: Evtl. after_create ?
      priorResult = Result.where(["student_id = ? and assessment_id = ?", @student.id, a]).order(:test_date).last

      @result = @student.results.create(assessment: a, prior_result: priorResult)
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
  end

  #GET /students/:student_id/results/:id/edit
  def edit
    @result = Result.find(params[:id])
    @student = Student.find(session[:student])
    unless @result.nil? || @result.student_id != @student.id
      @test = @result.assessment.test
      render layout: 'blank'
    else
      head 403
    end
  end

  private

  #Kind id aus Parametern holen und laden
  def set_student
    @student = Student.find(params[:student_id])
    if @student.group.user_id != @login.id      #TODO: Nicht für Schülertest
      redirect_to '/'
    end
  end

  def check_login
    if !session.has_key?(:student) || session[:student] != params[:student_id].to_i
      head 403
    end
  end
end
