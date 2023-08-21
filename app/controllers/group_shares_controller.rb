class GroupSharesController < ApplicationController
  before_action :set_group
  before_action :set_share, only: %i[update destroy]

  #POST /groups
  def create #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
    if @group.owner == @login
      @recipient = User.find_by_email(params[:email])
      if @recipient.nil?
        render json: { message: 'Diese Email-Adresse ist nicht registriert!' }, status: :forbidden
      elsif !@recipient.is_registered
        render json: {
                 message:
                   'Der Inhaber dieses Accounts hat die Registrierung noch nicht vollständig abgeschlossen!'
               },
               status: :forbidden
      elsif GroupShare.exists?(user: @recipient, group: @group)
        render json: {
                 message: 'Die Klasse wurde bereits mit diesem Nutzer geteilt!'
               },
               status: :forbidden
      else
        if GroupShare.create(
             group: @group,
             user: @recipient,
             owner: false,
             key: nil,
             read_only: params.require(:group_share)[:read_only],
             is_anonymous: params.require(:group_share)[:is_anonymous]
           )
          UserMailer
            .with(
              recipient: @recipient,
              share_key: params[:share_key],
              is_anonymous: params.require(:group_share)[:is_anonymous]
            )
            .new_share
            .deliver_later
        end
        render json: @group.as_hash(@login)
      end
    end
  end

  #PUT /groups/:id
  def update #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
    unless !@share.update(params.require(:group_share).permit(:key, :read_only, :is_anonymous))
      render json: @group.as_hash(@login)
    else
      head 304
    end
  end

  #DEL /groups/:id
  def destroy
    # @share.destroy can't be done in the if, because @group.owner needs the groupshare to determine ownership
    if (@group.owner == @login)
      #Share wurde vom Besitzer beendet => Klasse rendern
      @share.destroy
      render json: @group.as_hash(@login)
    else
      #Share wurde vom Benutzer beendet => Nur OK senden für View
      @share.destroy
      head :ok
    end
  end

  private

  #Gruppenummer aus Parametern holen und Gruppe laden
  def set_group
    @group = Group.find(params[:group_id])
    redirect_to '/' if @group.nil?
  end

  #Share aus Parametern holen und laden
  def set_share
    @share = GroupShare.find(params[:id])
    if @share.nil? || @share.group != @group ||
         (@share.user != @login && @share.group.owner != @login)
      redirect_to '/'
    end
  end
end
