class GroupsController < ApplicationController
  before_action :set_group, only: [:update, :destroy]

  #GET /klassenbuch
  def index
    @groups = @login.groups.all
  end

  #POST /groups
  def create
    g = @login.groups.new(params.require(:group).permit(:label))
    if g.save
      render json: g
    else
      head 304
    end
  end

  #PUT /groups/:id
  def update
    unless !@group.update_attributes(params.require(:group).permit(:label, :archive))
      render json: @group
    else
      head 304
    end
  end

  #DEL /groups/:id
  def destroy
    @group.destroy
    head :ok
  end

  private

  def set_group
    @group = @login.groups.find(params[:id])
    if @group.nil?
      redirect_to '/'
    end
  end

end
