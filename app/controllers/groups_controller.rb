class GroupsController < ApplicationController
  before_action :set_group, only: %i[update destroy]

  #GET /klassenbuch
  def index
    @data = {
      'groups': [Group.new] + @login.get_classbook_info,
      'single': @login.account_type == 2
    }
  end

  #POST /groups
  def create #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
    g = @login.groups.new(params.require(:group).permit(:label, :auth_token))
    if g.save
      #Neuen Share als Besitzer der Klasse anlegen, kann nur hier passieren, wegen key aus params
      GroupShare.create(
        group: g,
        user: @login,
        owner: true,
        read_only: false,
        key: params.require(:group)[:key]
      )
      render json: g.as_hash(@login)
    else
      head 304
    end
  end

  #PUT /groups/:id
  def update #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
    unless @group.read_only(@login) ||
             !@group.update(params.require(:group).permit(:label, :archive))
      render json: @group.as_hash(@login)
    else
      head 304
    end
  end

  #DEL /groups/:id
  def destroy
    @group.destroy unless @group.demo
    head :ok #200 als Rückmeldung an Vue-Component
  end

  private

  #Gruppenummer aus Parametern holen und Gruppe laden
  def set_group
    @group = @login.groups.find(params[:id]) #Nur aus den Gruppen des eingeloggten Users wählen.
    redirect_to '/' if @group.nil?
  end
end
