class MaterialsController < ApplicationController

  #GET /materials
  def index
    @materials = Material.all
  end

end