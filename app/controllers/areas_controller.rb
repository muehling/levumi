class AreasController < ApplicationController
  def destroy_safe
    area = Area.find(params[:id])
    if !area.nil? && !area.tests.exists?
      area.destroy
      head :ok
    else
      head 403
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
