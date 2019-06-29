class MaterialsController < ApplicationController
  before_action :set_material, except: [:index, :create]
  before_action :is_allowed, only: [:create, :destroy]

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
        Material.import(f.tempfile, params.has_key?(:replace))
      end
      render 'index_admin'
    end
  end

  #DEL /tests/:id
  def destroy
    @material.destroy
    render'index_admin'
  end

  private

  #Prüfen ob Nutzer die Berechtigung für Testaktualisierungen hat
  def is_allowed
    unless @login.has_capability?('material')
      redirect_to '/'
    end
  end

  #Test laden
  def set_material
    @material = Material.find(params[:id])
  end
end