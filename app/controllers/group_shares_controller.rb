class GroupSharesController < ApplicationController
  before_action :set_group
  before_action :set_share, only: [:update, :destroy]

  #POST /groups
  def create    #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
    if @group.owner == @login
      user = User.find_by_email(params[:email])
      if user.nil?
        head 404 #Nutzer nicht gefunden
      elsif GroupShare.exists?(user: user, group: @group)
        head 403 #Existiert schon
      else
        GroupShare.create(group: @group, user: user, owner: false, key: nil, read_only: params.require(:group_share)[:read_only].to_i)
        render json:  @group.as_hash(@login)
      end
    end
  end

  #PUT /groups/:id
  def update    #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
    unless !@share.update_attributes(params.require(:group_share).permit(:key, :read_only))
      render json: @group.as_hash(@login)
    else
      head 304
    end
  end

  #DEL /groups/:id
  def destroy
    @share.destroy
    if (@group.owner == @login)            #Share wurde vom Besitzer beendet => Klasse rendern
      render json: @group.as_hash(@login)
    else                                   #Share wurde vom Benutzer beendet => Nur OK senden für View
      head :ok
    end
  end

  private

  #Gruppenummer aus Parametern holen und Gruppe laden
  def set_group
    @group = Group.find(params[:group_id])
    if @group.nil?
      redirect_to '/'
    end
  end

  #Share aus Parametern holen und laden
  def set_share
    @share = GroupShare.find(params[:id])
    if @share.nil? || @share.group != @group || (@share.user != @login && @share.group.owner != @login)
      redirect_to '/'
    end
  end
end
