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

  #POST /materials
  def create
    if params.has_key?(:material) && !params[:material][:file].nil?
      params[:material][:file].each do |f|
        Material.import(f.tempfile)
      end
      render 'index_admin'
    end
  end
end