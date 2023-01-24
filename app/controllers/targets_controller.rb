class TargetsController < ApplicationController
  #POST /groups/:group_id/assessments/:assessment_id/targets
  def create
    a = Assessment.where(group_id: params[:group_id], test_id: params[:assessment_id]).first #Assessment wird durch Test identifiziert (vgl. AssessmentsController)
    # hier wird auch überprüft, ob ein entsprechendes Ziel bereits einmal angelegt wurde, um Dopplungen zu vermeiden
    unless a.nil? || !@login.groups.find(a.group.id) || Target.where(assessment_id: a.id, student_id: params.require(:target)[:student_id]).present?
      target = a.targets.create(params.require(:target).permit(:value, :student_id))
      #user_id und group_id werden nicht auf "Stimmigkeit" geprüft, ist aber wg. Bindung an Assessment unkritisch. Target wird ggf. nur nicht angezeigt werden.
      render json: target
    else
      head 403
    end
  end

  #GET /groups/:group_id/assessments/:assessment_id/targets
  def index
    a = Assessment.where(group_id: params[:group_id], test_id: params[:assessment_id]).first #Assessment wird durch Test identifiziert (vgl. AssessmentsController)
    #Sicherheitschecks - ggf. auslagern?
    unless a.nil? || !@login.groups.find(a.group.id)
      render json: a.get_targets
    else
      head 403
    end
  end

  #PUT /groups/:group_id/assessments/:assessment_id/targets/:id
  def update
    t = Target.find(params[:id])
    #Sicherheitschecks - ggf. auslagern?
    unless t.nil? || !@login.groups.find(t.assessment.group.id)
      t.update(params.require(:target).permit(:value))
      head :ok
    else
      head 403
    end
  end

  #DEL /groups/:group_id/assessments/:assessment_id/targets/:id
  def destroy
    t = Target.find(params[:id])
    #Sicherheitschecks - ggf. auslagern?
    unless t.nil? || !@login.groups.find(t.assessment.group.id)
      t.destroy
      head :ok
    else
      head 403
    end
  end
end
