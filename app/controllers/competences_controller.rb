class CompetencesController < ApplicationController
  def destroy_safe
    competence = Competence.find(params[:id])
    if !competence.nil? && !competence.tests.exists?
      competence.destroy
      head :ok
    else
      head 403
    end
  end

  def update
    competence = Competence.find(params[:id])
    if !competence.nil? && competence.update(name: params[:name])
      head :ok
    else
      head 304
    end
  end
end
