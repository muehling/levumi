class GroupsController < ApplicationController
  before_action :set_group, only: %i[update destroy get_test_data]

  #GET /klassenbuch
  def index
    @data = {
      'groups': [Group.new] + @login.get_classbook_info,
      'single': @login.account_type == 2,
      'login': @login
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
    if !@group.demo
      # delete students and groupshares here, as the shadow data needs info from the group and groupshare
      # which can't be accessed if the deletion is cascaded
      Student.where(group: @group.id).map { |student| student.create_shadow }
      GroupShare.where(group: @group.id).destroy_all
      @group.destroy
      head :ok #200 als Rückmeldung an Vue-Component
    else
      render json: {
               message: "groups_controller::destroy: group couldn't be destroyed"
             },
             status: :not_acceptable
    end
  end

  def get_test_data
    if !@group.nil?
      render json: @group.test_data
    else
      render json: {
               message: "groups_controller::get_test_data: group couldn't be found"
             },
             status: :not_found
    end
  end

  private

  #Gruppenummer aus Parametern holen und Gruppe laden
  def set_group
    @group = @login.groups.find(params[:id]) #Nur aus den Gruppen des eingeloggten Users wählen.
    redirect_to '/' if @group.nil?
  end
end
