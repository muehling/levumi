class AssessmentsController < ApplicationController
  before_action :set_group #Sicherheitscheck!
  before_action :set_assessment, only: [:show] #Sicherheitscheck!

  #GET /groups/:group_id/assessments/:id
  def show
    if @assessment.nil?
      head 404
    else
      render json: @assessment.get_grouped_results
    end
  end

  #POST /groups/:group_id/assessments
  def create
    t = Test.find(params[:test_id])
    unless t.nil?
      @group.assessments.create(test: t)
      head :ok
    end
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_assessment  #:id meint Test.id, nicht Assessment.id !
    @assessment =  @group.assessments.where(test_id: params[:id]).first
  end
end
