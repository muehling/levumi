class GroupsController < ApplicationController
  include GroupsHelper
  before_action :set_group, only: %i[update destroy get_test_data]

  #GET /groups
  def index
    shares_object = {}
    @login.group_shares.map { |c| shares_object[c.group_id] = c.key }
    @data = {
      'groups': @login.get_classbook_info,
      'single': @login.account_type == 2,
      'share_keys': shares_object
    }
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
      Student.where(group: params['_json'], is_demo: true).each { |student| student.destroy }
      head :ok
    end

    def add_demo_data
      params[:student_names].map! { |name| URI.decode_www_form_component(name) }
      students = []
      params[:student_names].each do |student_name|
        student = Student.create!(name: student_name, group_id: params[:group_id], is_demo: true)
        students.push(student.id)
      end
      assessment = Assessment.find_or_create_by(test_id: 328, group_id: params[:group_id])
      assessment_id = assessment.id
      test_date = '2025-02-18'
      id =
        Result.create(
          student_id: students[0],
          assessment_id: assessment_id,
          views: views_one,
          report: report_one,
          data: data_one,
          test_date: test_date
        )
      test_date = '2025-01-26'
      id =
        Result.new(
          student_id: students[1],
          assessment_id: assessment_id,
          views: views_one,
          report: report_one,
          data: data_one,
          test_date: test_date
        )
      id.save(validate: false)

      test_date = '2025-02-16'
      id =
        Result.new(
          student_id: students[1],
          assessment_id: assessment_id,
          views: views_two,
          report: report_two,
          data: data_two,
          test_date: test_date
        )
      id.save(validate: false)
      test_date = '2025-02-16'
      id =
        Result.new(
          student_id: students[0],
          assessment_id: assessment_id,
          views: views_three,
          report: report_three,
          data: data_three,
          test_date: test_date
        )
      id.save(validate: false)
      test_date = '2025-02-09'
      id =
        Result.new(
          student_id: students[0],
          assessment_id: assessment_id,
          views: views_four,
          report: report_four,
          data: data_four,
          test_date: test_date
        )
      id.save(validate: false)

      test_date = '2025-02-02'
      id =
        Result.new(
          student_id: students[1],
          assessment_id: assessment_id,
          views: views_four,
          report: report_four,
          data: data_four,
          test_date: test_date
        )
      id.save(validate: false)

      test_date = '2025-02-02'
      id =
        Result.new(
          student_id: students[0],
          assessment_id: assessment_id,
          views: views_five,
          report: report_five,
          data: data_five,
          test_date: test_date
        )
      id.save(validate: false)

      test_date = '2025-02-09'
      id =
        Result.new(
          student_id: students[1],
          assessment_id: assessment_id,
          views: views_five,
          report: report_five,
          data: data_five,
          test_date: test_date
        )
      id.save(validate: false)

      test_date = '2025-01-26'
      id =
        Result.new(
          student_id: students[0],
          assessment_id: assessment_id,
          views: views_six,
          report: report_six,
          data: data_six,
          test_date: test_date
        )
      id.save(validate: false)

      test_date = '2025-02-18'
      id =
        Result.new(
          student_id: students[1],
          assessment_id: assessment_id,
          views: views_six,
          report: report_six,
          data: data_six,
          test_date: test_date
        )
      id.save(validate: false)
      head :ok
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
end
