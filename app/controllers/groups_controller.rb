class GroupsController < ApplicationController
  before_action :set_group, only: [:update, :destroy]

  #GET /klassenbuch
  def index
    @data = {
        'groups': [Group.new] + @login.get_classbook_info,
        'single': @login.account_type == 2
    }
  end

  #POST /groups
  def create    #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
    g = @login.groups.new(params.require(:group).permit(:label))
    if g.save
      #Neue Capability als Besitzer der Klase anlegen
      GroupShare.create(group: g, user: @login, owner: true, read_only: false, key: params.require(:group).permit(:key))
      render json: g.as_hash(@login)
    else
      head 304
    end
  end

  #PUT /groups/:id
  def update    #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
    #TODO: Capability prüfen und ggf. löschen (archive)!
    unless !@group.update_attributes(params.require(:group).permit(:label, :archive))
      render json: @group.as_hash(@login)
    else
      head 304
    end
  end

  #DEL /groups/:id
  def destroy
    unless @group.demo
      #TODO: Capabilities löschen?
      @group.destroy
    end
    head :ok   #200 als Rückmeldung an Vue-Component
  end

  private

  #Gruppenummer aus Parametern holen und Gruppe laden
  def set_group
    @group = @login.groups.find(params[:id]) #Nur aus den Gruppen des eingeloggten Users wählen.
    if @group.nil?
      redirect_to '/'
    end
  end

end
