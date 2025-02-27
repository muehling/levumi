class GroupsController < ApplicationController
  include GroupsHelper
  before_action :set_group, only: %i[update destroy get_test_data]

  #GET /groups
  def index
    group_index_data
    render json: @data
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

      #render json: g.as_hash(@login)
      shares_object = {}
      @login.group_shares.map { |c| shares_object[c.group_id] = c.key }
      render json: { groups: @login.get_classbook_info, share_keys: shares_object }
    else
      head 304
    end
  end

  #PUT /groups/:id
  def update #Anzeige in Vue-Component, daher entweder JSON oder 304 als Rückmeldung
    if @group.read_only(@login)
      render json: {
               message: 'Sie haben nicht die notwendigen Rechte, um diese Klasse zu bearbeiten.'
             },
             status: :forbidden
      return
    end

    # group settings can be changed from various places - with this, you only need to pass
    # the changed settings from the frontend.
    if !@group.settings.nil? && !params[:group][:settings].nil?
      params[:group][:settings] = @group.settings.merge group_params[:settings]
    end

    if @group.update(group_params)
      shares_object = {}
      @login.group_shares.map { |c| shares_object[c.group_id] = c.key }
      render json: { groups: @login.get_classbook_info, share_keys: shares_object }
    else
      head 304
    end
  end

  #DEL /groups/:id
  def destroy
    head :forbidden if !@group.owned_by_login(@login)
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

    def delete_demo_data
      Student.where(group: params['_json'], is_demo: true).destroy_all
      head :ok
    end

    def add_demo_data
      params[:student_names].map! { |name| URI.decode_www_form_component(name) }
      students = []
      params[:student_names].each do |student_name|
        student = Student.create!(name: student_name, group_id: params[:group_id], is_demo: true)
        students.push(student.id)
      end
      test_id = Test.where(shorthand: 'ADD1').order(version: :desc).first.id
      assessment = Assessment.find_or_create_by(test_id: test_id, group_id: params[:group_id])
      assessment_id = assessment.id
      views = [views_one, views_two, views_three, views_four, views_five, views_six]
      reports = [report_one, report_two, report_three, report_four, report_five, report_six]
      datas = [data_one, data_two, data_three, data_four, data_five, data_six]
      test_dates = [7.days.ago, 14.days.ago, 21.days.ago, 28.days.ago, 35.days.ago]

      students.each do |student|
        randomized_dates = test_dates.shuffle
        views.each_with_index do |view, index|
          result =
            Result.new(
              student_id: student,
              assessment_id: assessment_id,
              views: view,
              report: reports[index],
              data: datas[index],
              test_date: randomized_dates[index]
            )
          result.save(validate: false)
        end
      end
      group_index_data
      render json: @data
    end
  end

  private

  #Gruppenummer aus Parametern holen und Gruppe laden
  def set_group
    @group = @login.groups.find(params[:id]) #Nur aus den Gruppen des eingeloggten Users wählen.
    redirect_to '/' if @group.nil?
  end

  def group_params
    params
      .require(:group)
      .permit(:label, :archive, settings: %i[font_family font_size calculator_layout])
  end
  def group_index_data
    shares_object = {}
    @login.group_shares.each { |c| shares_object[c.group_id] = c.key }
    @data = {
      'groups': @login.get_classbook_info,
      'single': @login.account_type == 2,
      'share_keys': shares_object
    }
  end
end
