class AnnotationsController < ApplicationController

  #POST /groups/:group_id/assessments/:assessment_id/annotations
  def create
    a = Assessment.find(params[:assessment_id])
    unless a.nil? || a.assessment.group != params[:group_id] || a.assessment.group.user != @login
      annotation = a.annotations.create(params.require(:annotation).permit(:start, :end, :content, :group_id, :user_id))
      #user_id und group_id werden nicht auf "Stimmigkeit" geprüft, ist aber wg. Bindung an Assessment unkritisch. Annotation wird ggf. nur nicht angezeigt werden.
      render json: annotation
    else
      head 403
    end
  end

  #DEL /groups/:group_id/assessments/:assessment_id/annotations/:id
  def destroy
    a = Annotation.find(params[:id])
    #Sicherheitschecks - ggf. auslagern?
    unless a.nil? || a.assessment != params[:assessment_id] || a.assessment.group != params[:group_id] || a.assessment.group.user != @login
      a.destroy
      head :ok
    else
      head 403
    end
  end
end
