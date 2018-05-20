# -*- encoding : utf-8 -*-
class AssessmentsController < ApplicationController
  before_action :set_assessment, only: [:show, :edit, :update, :destroy]
  before_action :set_user
  before_action :set_group
  before_action :is_allowed

  # GET /assessments
  # GET /assessments.json
  def index
    @assessments = Assessment.all
  end

  # GET /assessments/1
  # GET /assessments/1.json
  def show
    respond_to do |format|
      format.js
    end
  end

  # GET /assessments/new
  def new
    @assessment = Assessment.new
    existing = @group.assessments.map{|x| x.test}
    @tests = Test.where(:archive => false).order(:subject, :construct, :name) - existing
  end

  # GET /assessments/1/edit
  def edit
  end

  # POST /assessments
  # POST /assessments.json
  def create
    @assessment = nil?
    unless params[:test].nil?
      test = params[:test].to_i
      if Test.find(test)
        @assessment = @group.assessments.build(:test_id => test)
        @assessment.save
      end
    end
    @assessments = Assessment.all
    render :index
  end

  # PATCH/PUT /assessments/1
  # PATCH/PUT /assessments/1.json
  def update
  end

  # DELETE /assessments/1
  # DELETE /assessments/1.json
  def destroy
    @assessment.destroy
    respond_to do |format|
      format.html { redirect_to user_group_path(@user, @group) }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_assessment
      @assessment = Assessment.find(params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def set_group
      @group = Group.find(params[:group_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def assessment_params
      params[:assessment]
    end

    def is_allowed
      unless !@login_user.nil? && @login_user.hasCapability?("admin") || !@login_user.nil? && (params.has_key?(:user_id) && (@login_user.id == params[:user_id].to_i))
        redirect_to root_url
      end
    end
end
