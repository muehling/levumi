class AssessmentsController < ApplicationController
  before_action :set_group
  before_action :set_assessment, only: [:show, :update]

  #GET /groups/:group_id/assessments/:id
  def show                #Anzeige in Vue-Component, daher entweder JSON oder 404 als Rückmeldung
    if @assessment.nil?
      head 404
    else
      respond_to do |format|
        format.html {render 'users/show'}
        format.js {render json: @assessment.get_data}
      end
    end
  end

  #POST /groups/:group_id/assessments
  def create
    t = Test.find(params[:test_id])
    unless t.nil? || @group.read_only(@login)
      @group.assessments.create(test: t) if @group.assessments.find_by_test_id(t.id).nil?
      head 200
    end
  end

  #PUT /groups/:group_id/assessments/:id
  def update    #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
    if params.require(:assessment).has_key?(:exclude) && @assessment.exclude(params.require(:assessment)[:exclude])
      head 200
    elsif params.require(:assessment).has_key?(:include) && @assessment.include(params.require(:assessment)[:include])
        head 200
    elsif @assessment.update_attributes(params.require(:assessment).permit(:active))
      head 200
    else
      head 304
    end
  end

  #GET /groups/:group_id/assessments
  def index
    #Nur nicht-leere Assessments anzeigen.
    data = @group.assessments.select{|a| !Result.find_by_assessment_id(a.id).nil? && !a.test.archive}.map{|a| {active: a.active, test: a.test.id, name: a.test.full_name, student_test: a.test.student_test}}
    respond_to do |format|
      format.js {render json: data}
    end
  end

  private

  #Gruppenummer aus Parametern holen und Gruppe laden
  def set_group
    @group = @login.groups.find(params[:group_id])
    if @group.nil?
      redirect_to '/'
    end
  end

  #Assessment laden
  def set_assessment  #:id meint Test.id, nicht Assessment.id (aus Auswahldialog)
    @assessment = @group.assessments.where(test_id: params[:id]).first
  end
end
