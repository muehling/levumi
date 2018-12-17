class GroupsController < ApplicationController

  #GET /
  def index
    @groups = @user.groups.all
  end

  #POST /groups
  def create
    g = @user.groups.new(params.require(:group).permit(:label))
    if g.save
      render json: g
    else
      head 304
    end
  end

  #PUT /groups/:id
  def update
    g = @user.groups.find(params[:id])
    unless g.nil? || !g.update_attributes(params.require(:group).permit(:label, :archive))
      render json: g
    else
      head 304
    end
  end

  #DEL /groups/:id
  def destroy
    g = @user.groups.find(params[:id])
    unless g.nil?
      g.destroy
    end
    head :ok
  end

end
