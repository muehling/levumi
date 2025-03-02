class GroupSharesController < ApplicationController
  before_action :set_group
  before_action :set_share, only: %i[update destroy]

  #POST /groups
  def create
    return if @group.owner != @login

    @recipient = User.find_by_email(params[:email])
    if @recipient.nil?
      render json: { message: 'Diese Email-Adresse ist nicht registriert!' }, status: :forbidden
    elsif !@recipient.is_registered
      render json: {
               message:
                 'Der Inhaber dieses Accounts hat die Registrierung noch nicht vollständig abgeschlossen!'
             },
             status: :forbidden
    elsif GroupShare.exists?(user: @recipient, group: @group) &&
          group_shares_attributes[:is_transfer].nil?
      render json: {
               message: 'Die Klasse wurde bereits mit diesem Nutzer geteilt!'
             },
             status: :forbidden
    else
      if GroupShare.create(
           group: @group,
           user: @recipient,
           owner: group_shares_attributes[:is_transfer] || false,
           key: nil,
           read_only: group_shares_attributes[:read_only],
           is_anonymous: group_shares_attributes[:is_anonymous]
         )
        if group_shares_attributes[:is_transfer] == true
          UserMailer
            .with(
              sender: @login.email,
              group_label: @group.label,
              recipient: @recipient,
              share_key: group_shares_attributes[:share_key],
              is_new_share: group_shares_attributes[:is_new_share]
            )
            .transfer_group
            .deliver_later
        else
          UserMailer
            .with(
              sender: @login.email,
              group_label: @group.label,
              recipient: @recipient,
              share_key: group_shares_attributes[:share_key],
              is_anonymous: group_shares_attributes[:is_anonymous]
            )
            .new_share
            .deliver_later
        end
      end
      render json: @group.as_hash(@login)
    end
  end

  def initialize_transfer
    return if @group.owner != @login
  end

  #def transfer_group
  #  if success
  #    shares_object = {}
  #    @login.group_shares.map { |c| shares_object[c.group_id] = c.key }
  #    UserMailer
  #      .with(
  #        sender: @login.email,
  #        group_label: @group.label,
  #        recipient: @recipient,
  #        share_key: params[:share_key],
  #        is_new_share: is_new_share
  #      )
  #      .transfer_group
  #      .deliver_later
  #    render json: { groups: @login.get_classbook_info, share_keys: shares_object, status: :ok }
  #  else
  #    render json: {
  #             message: 'groups_controller::transfer_group: transfer failed',
  #             status: :unprocessable_entity
  #           }
  #  end
  #end

  #PUT /groups/:id
  def update
    p = group_shares_attributes.to_h.slice(:key, :read_only, :is_anonymous)
    if @share.update(p)
      if params[:group_share][:is_transfer]
        # make old owner no longer the owner
        old_owner_share =
          GroupShare.where(group_id: @share.group_id, owner: true).where.not(user_id: @login.id)
        old_owner_share.update(owner: false)

        # if necessary, delete old share of new owner
        old_share = GroupShare.where(user_id: @login.id, group_id: @share.group_id, owner: false)
        old_share.destroy if !old_share.empty?
      end
      render json: @group.as_hash(@login)
    else
      head 304
    end
  end

  #DEL /groups/:id
  def destroy
    # @share.destroy can't be done outside the if, because @group.owner needs the groupshare to determine ownership
    if (@group.owner == @login)
      #Share wurde vom Besitzer beendet => Klasse rendern
      @share.destroy

      #render json: @group.as_hash(@login)
      render json: @login.get_classbook_info
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

  def group_shares_attributes
    params.require(:group_share).permit(:key, :read_only, :is_anonymous, :share_key, :is_transfer)
  end
end
