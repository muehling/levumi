class MaterialsController < ApplicationController
  before_action :set_material, only: [:show, :edit, :update, :destroy]
  before_action :is_allowed, only: [:edit, :update, :destroy, :new]

  # GET /materials
  # GET /materials.json
  def index
    @materials = Material.all
  end

  # GET /materials/1
  # GET /materials/1.json
  def show
  end


  # GET /materials/1/edit
  def edit
  end

  # PATCH/PUT /materials/1
  # PATCH/PUT /materials/1.json
  def update
    respond_to do |format|
      if @material.update(material_params)
        format.js
      else
        format.js { render :edit }
      end
    end
  end

  # DELETE /materials/1
  # DELETE /materials/1.json
  def destroy
    @material.destroy
    respond_to do |format|
      format.html { redirect_to materials_url, notice: 'Fördermaterial wurde gelöscht.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_material
      @material = Material.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def material_params
      params.require(:material).permit(:subject, :construct, :block, :exercisetype, :exerciseinfo, :blockinfo)
    end

    def is_allowed
      unless @login_user.nil? &&@login_user.account_type!=-1&& @login_user.hasCapability?("test")
        redirect_to root_url
      end
    end
end
