class AreasController < ApplicationController
  def destroy_safe
    area = Area.find(params[:id])
    if !area.nil? && !area.tests.exists?
      area.destroy
      head :ok
    else
      render json: {
               message: "areas_controller:destroy_safe: area couldn't be deleted"
             },
             status: :forbidden
    end
  end

  def update
    area = Area.find(params[:id])
    if !area.nil? && area.update(name: params[:name])
      head :ok
    else
      head 304
    end
  end
end
