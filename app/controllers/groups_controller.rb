# -*- encoding : utf-8 -*-
class GroupsController < ApplicationController
  before_action :set_user
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :is_allowed
  # GET /groups
  # GET /groups.json
  def index
    if params.has_key?(:destroyed)
      @destroyed_group = params[:destroyed]
    else
      @destroyed_group = ""
    end
    @groups = @user.groups
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @groups = @user.groups
    @group = @user.groups.build(group_params)
    @group.demo = false
    @group.export = true
    respond_to do |format|
      if @group.save
        format.js
      else
        format.js {render :new}
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.js
        format.html {
          redirect_to user_groups_path(@user)
        }
      else
        format.js {
        @group.reload
        render :edit
        }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    unless @group.demo
      destroyed_group = @group.id
      @group.destroy
    end
    respond_to do |format|
      format.html {
        #destroyed_group in params to get it in index<- lost as instance-variable
        redirect_to user_groups_url(@user, destroyed: destroyed_group), notice: 'Klasse wurde gelöscht.'
      }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :archive)
    end

    def is_allowed
      unless !@login_user.nil? && @login_user.hasCapability?("admin") || !@login_user.nil? && (params.has_key?(:user_id) && (@login_user.id == params[:user_id].to_i))
        redirect_to root_url
      end
    end
end
