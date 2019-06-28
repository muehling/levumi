class MaterialsController < ApplicationController

  #GET /materials
  def index
    if params[:admin] && @login.has_capability?('material')
      render 'index_admin'
    else
      @data = Material.get_material_info
      render 'index'
    end
  end

end