class ResultsController < ApplicationController
  before_action :set_student

  #POST /students/:student_id/results
  def create
    if (params.has_key? :test_id)
      @test = Test.find(params[:test_id])
      a = Assessment.where(group_id: @student.group_id, test_id: @test.id).pluck(:id).first       #Assessment aus student_id und test_id bestimmen
      @result = @student.results.create(assessment_id: a)
    end
    render 'edit', layout: 'blank'
  end

  #PUT /students/:student_id/results/:id
  def update
    @result = Result.find(params[:id])
    @result.test_date = DateTime.now
    @result.save
  end

  private

  #Kind id aus Parametern holen und laden
  def set_student
    @student = Student.find(params[:student_id])
    if @student.group.user_id != @login.id      #TODO: Nicht für Schülertest
      redirect_to '/'
    end
  end

end
