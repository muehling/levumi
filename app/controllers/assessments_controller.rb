class AssessmentsController < ApplicationController
  before_action :set_group
  before_action :set_assessment, only: [:show]

  #GET /groups/:group_id/assessments/:id
  def show                #Anzeige in Vue-Component, daher entweder JSON oder 404 als Rückmeldung
    if @assessment.nil?
      head 404
    else
      render json: @assessment.get_data
    end
  end

  #POST /groups/:group_id/assessments
  def create
    t = Test.find(params[:test_id])
    unless t.nil?
      @group.assessments.create(test: t)
      head :ok   #200 als Rückmeldung an Vue-Component
    end
  end

  private

  #Gruppenummer aus Parametern holen und Gruppe laden
  def set_group
    @group = Group.find(params[:group_id])
    if @group.user_id != @login.id
      redirect_to '/'
    end
  end

  #Assessment laden
  def set_assessment  #:id meint Test.id, nicht Assessment.id (aus Auswahldialog)
    @assessment = @group.assessments.where(test_id: params[:id]).first
  end
end
