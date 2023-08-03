class AnnotationsController < ApplicationController
  #POST /groups/:group_id/assessments/:assessment_id/annotations
  def create
    a = Assessment.where(group_id: params[:group_id], test_id: params[:assessment_id]).first #Assessment wird durch Test identifiziert (vgl. AssessmentsController)
    unless a.nil? || !@login.groups.find(a.group.id)
      annotation =
        a.annotations.create(
          params
            .require(:annotation)
            .permit(:start, :end, :annotation_category_id, :trend_threshold, :group_id, :student_id, :view)
        )

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
    unless a.nil? || !@login.groups.find(a.assessment.group.id)
      a.destroy
      head :ok
    else
      head 403
    end
  end
end
