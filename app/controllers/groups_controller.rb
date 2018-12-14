class GroupsController < ApplicationController

  #GET /
  def index
    @groups = @user.groups.all
  end

  #POST /groups.html
  def create
    g = @user.groups.new(params.require(:group).permit(:label))
    if g.save
      render json: g
    else
      head 500
    end
  end

  #PUT /groups/:id
  def update
    g = @user.groups.find(params[:id])
    unless g.nil?
      g.update_attributes(params.require(:group).permit(:label, :archive))
    end
    head :ok
  end

  #DEL /groups/:id
  def destroy
    g = @user.groups.find(params[:id])
    unless g.nil?
      g.destroy
    end
    head :ok
  end

  private
  def group_params
    params.require(:group).permit(:label)
  end

end
