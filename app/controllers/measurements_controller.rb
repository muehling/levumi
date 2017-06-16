# -*- encoding : utf-8 -*-
class MeasurementsController < ApplicationController
  before_action :set_measurement, only: [:show, :edit, :update, :destroy]
  before_action :set_assessment
  before_action :set_user
  before_action :set_group
  before_filter :is_allowed

  # GET /measurements
  # GET /measurements.json
  def index
    @measurements = Measurement.all
  end

  # GET /measurements/1
  # GET /measurements/1.json
  def show
  end

  # GET /measurements/new
  def new
    @measurement = @assessment.measurements.new
  end

  # GET /measurements/1/edit
  def edit
  end

  # POST /measurements
  # POST /measurements.json
  def create
    @measurement = @assessment.measurements.new(measurement_params)

    respond_to do |format|
      if @measurement.save
        format.js
      else
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /measurements/1
  # PATCH/PUT /measurements/1.json
  def update
    respond_to do |format|
      if @measurement.update(measurement_params)
        format.js { render :index } #TODO ??
      else
        format.js { render :edit }
      end
    end
  end

  # DELETE /measurements/1
  # DELETE /measurements/1.json
  def destroy
    @measurement.destroy
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_measurement
      @measurement = Measurement.find(params[:id])
    end

    def set_assessment
      @assessment = Assessment.find(params[:assessment_id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_group
      @group = Group.find(params[:group_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def measurement_params
      params.require(:measurement).permit(:date)
    end

    def is_allowed
      unless @login.instance_of?(User) && @login.hasCapability?("admin") || @login.instance_of?(User) && (params.has_key?(:user_id) && (@login.id == params[:user_id].to_i))
        redirect_to root_url
      end
    end
end
