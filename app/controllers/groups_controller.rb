class GroupsController < ApplicationController

  #GET /
  def index
    @groups = @user.groups.all
  end

  #POST /groups.html
  def create
    @user.groups.create(params.require(:group).permit(:label))
    redirect_to :students
  end

  #PUT /groups/:id
  def update
    g = @user.groups.find(params[:id])
    unless g.nil?
      g.update_attributes(params.require(:group).permit(:label, :archive))
    end
    render status: :ok
  end

  #DEL /groups/:id
  def destroy
    g = @user.groups.find(params[:id])
    unless g.nil?
      g.destroy
    end
    render status: :ok
  end

  private
  def group_params
    params.require(:group).permit(:label)
  end

end
