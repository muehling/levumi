class MaterialsController < ApplicationController
  before_action :set_material, except: %i[index create get_material_data]
  before_action :is_allowed, only: %i[create destroy]

  #GET /materials
  def index
    if params[:admin] && @login.has_capability?('material')
      render 'index_admin'
    else
      if params[:test] && params[:group]
        render json: Material.get_suggestions(params[:test], params[:group])
      else
        @data = Material.get_material_info
        render 'index'
      end
    end
  end

  #POST /materials
  def create
    if params.has_key?(:material) && !params[:material][:file].nil?
      params[:material][:file].each do |f|
        Material.import(f.tempfile, params.has_key?(:replace)) if f.present?
      end
      redirect_to '/materials?admin=true', status: :see_other
    end
  end

  #DEL /tests/:id
  def destroy
    @material.destroy
    render 'index_admin'
  end

  def get_material_data
    @data = Material.get_material_info
  end

  private

  #Prüfen ob Nutzer die Berechtigung für Testaktualisierungen hat
  def is_allowed
    redirect_to '/' unless @login.has_capability?('material')
  end

  #Test laden
  def set_material
    @material = Material.find(params[:id])
  end
end
