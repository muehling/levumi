class MaterialsController < ApplicationController

  #GET /materials
  def index
    @data = Material.get_material_info
  end

end