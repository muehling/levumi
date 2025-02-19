class GroupsController < ApplicationController
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
      Student
        .where(group: params['_json'], is_demo: true)
        .each do |student|
          Result.where(student_id: student.id).destroy_all
          student.destroy
        end
      head :ok
    end

    def add_demo_data
      params[:student_names].map! { |name| URI.decode_www_form_component(name) }
      students = []
      params[:student_names].each do |student_name|
        student = Student.create!(name: student_name, group_id: params[:group_id], is_demo: true)
        students.push(student.id)
      end
      assessment_id = Assessment.create(test_id: 328, group_id: params[:group_id]).id

      views = {
        'V1': 18,
        'V2': {
          'LG': '90.0',
          'FGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 0</strong><hr class='my-0'/><br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 1</strong><hr class='my-0'/>(6 + 4 = 10)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 1</strong><hr class='my-0'/>(2 + 7 = 9)<br/></br/>",
          'LGM': '4',
          'RGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 6</strong><hr class='my-0'/>(2 + 1 = 3), (9 + 1 = 10), (4 + 1 = 5), (9 + 0 = 9), (3 + 1 = 4), (7 + 1 = 8)<br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 6</strong><hr class='my-0'/>(3 + 3 = 6), (7 + 3 = 10), (4 + 2 = 6), (4 + 4 = 8), (8 + 2 = 10), (4 + 3 = 7)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 6</strong><hr class='my-0'/>(2 + 6 = 8), (2 + 4 = 6), (4 + 5 = 9), (1 + 5 = 6), (3 + 5 = 8), (1 + 7 = 8)<br/></br/>"
        },
        'V3': {
          'LG': '90.0',
          'FGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 0</strong><hr class='my-0'/><br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 1</strong><hr class='my-0'/>(6 + 4 = 10)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 1</strong><hr class='my-0'/>(2 + 7 = 9)<br/></br/>",
          'LGM': '4',
          'RGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 6</strong><hr class='my-0'/>(2 + 1 = 3), (9 + 1 = 10), (4 + 1 = 5), (9 + 0 = 9), (3 + 1 = 4), (7 + 1 = 8)<br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 6</strong><hr class='my-0'/>(3 + 3 = 6), (7 + 3 = 10), (4 + 2 = 6), (4 + 4 = 8), (8 + 2 = 10), (4 + 3 = 7)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 6</strong><hr class='my-0'/>(2 + 6 = 8), (2 + 4 = 6), (4 + 5 = 9), (1 + 5 = 6), (3 + 5 = 8), (1 + 7 = 8)<br/></br/>",
          'SUM': 18
        }
      }

      report = {
        'trend': 1,
        'negative': %w[I62 I15],
        'positive': %w[I36 I33 I18 I06 I27 I61 I53 I26 I07 I25 I55 I17 I28 I02 I04 I16 I05 I64],
        'result_number': 3
      }

      data = [
        {
          'item': 'I62',
          'time': 12_656,
          'group': 3,
          'answer': '10',
          'result': 0,
          'description': '2 + 7 = 9'
        },
        {
          'item': 'I36',
          'time': 10_378,
          'group': 1,
          'answer': '3',
          'result': 1,
          'description': '2 + 1 = 3'
        },
        {
          'item': 'I33',
          'time': 10_278,
          'group': 2,
          'answer': '6',
          'result': 1,
          'description': '3 + 3 = 6'
        },
        {
          'item': 'I18',
          'time': 17_141,
          'group': 3,
          'answer': '8',
          'result': 1,
          'description': '2 + 6 = 8'
        },
        {
          'item': 'I15',
          'time': 39_283,
          'group': 2,
          'answer': '13',
          'result': 0,
          'description': '6 + 4 = 10'
        },
        {
          'item': 'I06',
          'time': 11_972,
          'group': 1,
          'answer': '10',
          'result': 1,
          'description': '9 + 1 = 10'
        },
        {
          'item': 'I27',
          'time': 37_913,
          'group': 2,
          'answer': '10',
          'result': 1,
          'description': '7 + 3 = 10'
        },
        {
          'item': 'I61',
          'time': 23_398,
          'group': 3,
          'answer': '6',
          'result': 1,
          'description': '2 + 4 = 6'
        },
        {
          'item': 'I53',
          'time': 7367,
          'group': 1,
          'answer': '5',
          'result': 1,
          'description': '4 + 1 = 5'
        },
        {
          'item': 'I26',
          'time': 7288,
          'group': 3,
          'answer': '9',
          'result': 1,
          'description': '4 + 5 = 9'
        },
        {
          'item': 'I07',
          'time': 14_818,
          'group': 2,
          'answer': '6',
          'result': 1,
          'description': '4 + 2 = 6'
        },
        {
          'item': 'I25',
          'time': 12_961,
          'group': 1,
          'answer': '9',
          'result': 1,
          'description': '9 + 0 = 9'
        },
        {
          'item': 'I55',
          'time': 18_056,
          'group': 3,
          'answer': '6',
          'result': 1,
          'description': '1 + 5 = 6'
        },
        {
          'item': 'I17',
          'time': 13_192,
          'group': 1,
          'answer': '4',
          'result': 1,
          'description': '3 + 1 = 4'
        },
        {
          'item': 'I28',
          'time': 6201,
          'group': 2,
          'answer': '8',
          'result': 1,
          'description': '4 + 4 = 8'
        },
        {
          'item': 'I02',
          'time': 8150,
          'group': 1,
          'answer': '8',
          'result': 1,
          'description': '7 + 1 = 8'
        },
        {
          'item': 'I04',
          'time': 12_124,
          'group': 3,
          'answer': '8',
          'result': 1,
          'description': '3 + 5 = 8'
        },
        {
          'item': 'I16',
          'time': 13_632,
          'group': 2,
          'answer': '10',
          'result': 1,
          'description': '8 + 2 = 10'
        },
        {
          'item': 'I05',
          'time': 17_335,
          'group': 2,
          'answer': '7',
          'result': 1,
          'description': '4 + 3 = 7'
        },
        {
          'item': 'I64',
          'time': 5861,
          'group': 3,
          'answer': '8',
          'result': 1,
          'description': '1 + 7 = 8'
        }
      ]

      test_date = '2025-02-18'

      id =
        Result.create(
          student_id: students[0],
          assessment_id: assessment_id,
          views: views,
          report: report,
          data: data,
          test_date: test_date
        )
      test_date = '2025-01-26'
      id =
        Result.new(
          student_id: students[1],
          assessment_id: assessment_id,
          views: views,
          report: report,
          data: data,
          test_date: test_date
        )
      id.save(validate: false)

      views = {
        'V1': 17,
        'V2': {
          'LG': '85.0',
          'FGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 0</strong><hr class='my-0'/><br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 1</strong><hr class='my-0'/>(6 + 4 = 10)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 1</strong><hr class='my-0'/>(2 + 7 = 9)<br/></br/>",
          'LGM': '4',
          'RGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 6</strong><hr class='my-0'/>(2 + 1 = 3), (9 + 1 = 10), (4 + 1 = 5), (9 + 0 = 9), (3 + 1 = 4), (7 + 1 = 8)<br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 6</strong><hr class='my-0'/>(3 + 3 = 6), (7 + 3 = 10), (4 + 2 = 6), (4 + 4 = 8), (8 + 2 = 10), (4 + 3 = 7)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 6</strong><hr class='my-0'/>(2 + 6 = 8), (2 + 4 = 6), (4 + 5 = 9), (1 + 5 = 6), (3 + 5 = 8), (1 + 7 = 8)<br/></br/>"
        },
        'V3': {
          'LG': '85.0',
          'FGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 0</strong><hr class='my-0'/><br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 1</strong><hr class='my-0'/>(6 + 4 = 10)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 1</strong><hr class='my-0'/>(2 + 7 = 9)<br/></br/>",
          'LGM': '4',
          'RGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 6</strong><hr class='my-0'/>(2 + 1 = 3), (9 + 1 = 10), (4 + 1 = 5), (9 + 0 = 9), (3 + 1 = 4), (7 + 1 = 8)<br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 6</strong><hr class='my-0'/>(3 + 3 = 6), (7 + 3 = 10), (4 + 2 = 6), (4 + 4 = 8), (8 + 2 = 10), (4 + 3 = 7)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 6</strong><hr class='my-0'/>(2 + 6 = 8), (2 + 4 = 6), (4 + 5 = 9), (1 + 5 = 6), (3 + 5 = 8), (1 + 7 = 8)<br/></br/>",
          'SUM': 17
        }
      }

      report = {
        'trend': 1,
        'negative': %w[I62 I15 I64],
        'positive': %w[I36 I33 I18 I06 I27 I61 I53 I26 I07 I25 I55 I17 I28 I02 I04 I16 I05],
        'result_number': 4
      }

      data = [
        {
          'item': 'I62',
          'time': 12_656,
          'group': 3,
          'answer': '10',
          'result': 0,
          'description': '2 + 7 = 9'
        },
        {
          'item': 'I36',
          'time': 10_378,
          'time': 11_972,
          'group': 1,
          'answer': '10',
          'result': 1,
          'description': '9 + 1 = 10'
        },
        { 'answer': '3', 'result': 1, 'description': '2 + 1 = 3' },
        {
          'item': 'I33',
          'time': 10_278,
          'group': 2,
          'answer': '6',
          'result': 1,
          'description': '3 + 3 = 6'
        },
        {
          'item': 'I18',
          'time': 17_141,
          'group': 3,
          'answer': '8',
          'result': 1,
          'description': '2 + 6 = 8'
        },
        {
          'item': 'I15',
          'time': 39_283,
          'group': 2,
          'answer': '13',
          'result': 0,
          'description': '6 + 4 = 10'
        },
        {
          'item': 'I06',
          'item': 'I27',
          'time': 37_913,
          'group': 2,
          'answer': '10',
          'result': 1,
          'description': '7 + 3 = 10'
        },
        { 'item': 'I61', 'time': 23_398, 'result': 1, 'description': '2 + 4 = 6' },
        {
          'item': 'I53',
          'time': 7367,
          'group': 1,
          'answer': '5',
          'result': 1,
          'description': '4 + 1 = 5'
        },
        {
          'item': 'I26',
          'time': 7288,
          'group': 3,
          'answer': '9',
          'result': 1,
          'description': '4 + 5 = 9'
        },
        {
          'item': 'I07',
          'time': 14_818,
          'group': 2,
          'answer': '6',
          'result': 1,
          'description': '4 + 2 = 6'
        },
        {
          'item': 'I25',
          'time': 12_961,
          'group': 1,
          'answer': '9',
          'result': 1,
          'description': '9 + 0 = 9'
        },
        {
          'item': 'I55',
          'time': 18_056,
          'group': 3,
          'answer': '6',
          'result': 1,
          'description': '1 + 5 = 6'
        },
        {
          'item': 'I17',
          'time': 13_192,
          'group': 1,
          'answer': '4',
          'result': 1,
          'description': '3 + 1 = 4'
        },
        {
          'item': 'I28',
          'time': 6201,
          'group': 2,
          'answer': '8',
          'result': 1,
          'description': '4 + 4 = 8'
        },
        {
          'item': 'I02',
          'time': 8150,
          'group': 1,
          'answer': '8',
          'result': 1,
          'description': '7 + 1 = 8'
        },
        {
          'item': 'I04',
          'time': 12_124,
          'group': 3,
          'answer': '8',
          'result': 1,
          'description': '3 + 5 = 8'
        },
        {
          'item': 'I16',
          'time': 13_632,
          'group': 2,
          'answer': '10',
          'result': 1,
          'description': '8 + 2 = 10'
        },
        {
          'item': 'I05',
          'time': 17_335,
          'group': 2,
          'answer': '7',
          'result': 1,
          'description': '4 + 3 = 7'
        },
        {
          'item': 'I64',
          'time': 5861,
          'group': 3,
          'answer': '9',
          'result': 0,
          'description': '1 + 7 = 8'
        }
      ]

      test_date = '2025-02-16'
      id =
        Result.new(
          student_id: students[1],
          assessment_id: assessment_id,
          views: views,
          report: report,
          data: data,
          test_date: test_date
        )
      id.save(validate: false)

      views = {
        'V1': 16,
        'V2': {
          'LG': '80.0',
          'FGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 0</strong><hr class='my-0'/><br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 1</strong><hr class='my-0'/>(6 + 4 = 10)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 1</strong><hr class='my-0'/>(2 + 7 = 9)<br/></br/>",
          'LGM': '4',
          'RGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 6</strong><hr class='my-0'/>(2 + 1 = 3), (9 + 1 = 10), (4 + 1 = 5), (9 + 0 = 9), (3 + 1 = 4), (7 + 1 = 8)<br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 6</strong><hr class='my-0'/>(3 + 3 = 6), (7 + 3 = 10), (4 + 2 = 6), (4 + 4 = 8), (8 + 2 = 10), (4 + 3 = 7)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 6</strong><hr class='my-0'/>(2 + 6 = 8), (2 + 4 = 6), (4 + 5 = 9), (1 + 5 = 6), (3 + 5 = 8), (1 + 7 = 8)<br/></br/>"
        },
        'V3': {
          'LG': '80.0',
          'FGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 0</strong><hr class='my-0'/><br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 1</strong><hr class='my-0'/>(6 + 4 = 10)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 1</strong><hr class='my-0'/>(2 + 7 = 9)<br/></br/>",
          'LGM': '4',
          'RGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 6</strong><hr class='my-0'/>(2 + 1 = 3), (9 + 1 = 10), (4 + 1 = 5), (9 + 0 = 9), (3 + 1 = 4), (7 + 1 = 8)<br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 6</strong><hr class='my-0'/>(3 + 3 = 6), (7 + 3 = 10), (4 + 2 = 6), (4 + 4 = 8), (8 + 2 = 10), (4 + 3 = 7)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 6</strong><hr class='my-0'/>(2 + 6 = 8), (2 + 4 = 6), (4 + 5 = 9), (1 + 5 = 6), (3 + 5 = 8), (1 + 7 = 8)<br/></br/>",
          'SUM': 16
        }
      }

      report = {
        'trend': 1,
        'negative': %w[I62 I15 I64 I36],
        'positive': %w[I33 I18 I06 I27 I61 I53 I26 I07 I25 I55 I17 I28 I02 I04 I16 I05],
        'result_number': 4
      }

      data = [
        {
          'item': 'I62',
          'time': 12_656,
          'group': 3,
          'answer': '10',
          'result': 0,
          'description': '2 + 7 = 9'
        },
        {
          'item': 'I36',
          'time': 10_378,
          'time': 11_972,
          'group': 1,
          'answer': '11',
          'result': 0,
          'description': '9 + 1 = 10'
        },
        { 'answer': '3', 'result': 1, 'description': '2 + 1 = 3' },
        {
          'item': 'I33',
          'time': 10_278,
          'group': 2,
          'answer': '6',
          'result': 1,
          'description': '3 + 3 = 6'
        },
        {
          'item': 'I18',
          'time': 17_141,
          'group': 3,
          'answer': '8',
          'result': 1,
          'description': '2 + 6 = 8'
        },
        {
          'item': 'I15',
          'time': 39_283,
          'group': 2,
          'answer': '13',
          'result': 0,
          'description': '6 + 4 = 10'
        },
        {
          'item': 'I06',
          'item': 'I27',
          'time': 37_913,
          'group': 2,
          'answer': '10',
          'result': 1,
          'description': '7 + 3 = 10'
        },
        { 'item': 'I61', 'time': 23_398, 'result': 1, 'description': '2 + 4 = 6' },
        {
          'item': 'I53',
          'time': 7367,
          'group': 1,
          'answer': '5',
          'result': 1,
          'description': '4 + 1 = 5'
        },
        {
          'item': 'I26',
          'time': 7288,
          'group': 3,
          'answer': '9',
          'result': 1,
          'description': '4 + 5 = 9'
        },
        {
          'item': 'I07',
          'time': 14_818,
          'group': 2,
          'answer': '6',
          'result': 1,
          'description': '4 + 2 = 6'
        },
        {
          'item': 'I25',
          'time': 12_961,
          'group': 1,
          'answer': '9',
          'result': 1,
          'description': '9 + 0 = 9'
        },
        {
          'item': 'I55',
          'time': 18_056,
          'group': 3,
          'answer': '6',
          'result': 1,
          'description': '1 + 5 = 6'
        },
        {
          'item': 'I17',
          'time': 13_192,
          'group': 1,
          'answer': '4',
          'result': 1,
          'description': '3 + 1 = 4'
        },
        {
          'item': 'I28',
          'time': 6201,
          'group': 2,
          'answer': '8',
          'result': 1,
          'description': '4 + 4 = 8'
        },
        {
          'item': 'I02',
          'time': 8150,
          'group': 1,
          'answer': '8',
          'result': 1,
          'description': '7 + 1 = 8'
        },
        {
          'item': 'I04',
          'time': 12_124,
          'group': 3,
          'answer': '8',
          'result': 1,
          'description': '3 + 5 = 8'
        },
        {
          'item': 'I16',
          'time': 13_632,
          'group': 2,
          'answer': '10',
          'result': 1,
          'description': '8 + 2 = 10'
        },
        {
          'item': 'I05',
          'time': 17_335,
          'group': 2,
          'answer': '7',
          'result': 1,
          'description': '4 + 3 = 7'
        },
        {
          'item': 'I64',
          'time': 5861,
          'group': 3,
          'answer': '9',
          'result': 0,
          'description': '1 + 7 = 8'
        }
      ]

      test_date = '2025-02-16'
      id =
        Result.new(
          student_id: students[0],
          assessment_id: assessment_id,
          views: views,
          report: report,
          data: data,
          test_date: test_date
        )
      id.save(validate: false)

      views = {
        'V1': 15,
        'V2': {
          'LG': '75.0',
          'FGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 0</strong><hr class='my-0'/><br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 1</strong><hr class='my-0'/>(6 + 4 = 10)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 1</strong><hr class='my-0'/>(2 + 7 = 9)<br/></br/>",
          'LGM': '4',
          'RGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 6</strong><hr class='my-0'/>(2 + 1 = 3), (9 + 1 = 10), (4 + 1 = 5), (9 + 0 = 9), (3 + 1 = 4), (7 + 1 = 8)<br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 6</strong><hr class='my-0'/>(3 + 3 = 6), (7 + 3 = 10), (4 + 2 = 6), (4 + 4 = 8), (8 + 2 = 10), (4 + 3 = 7)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 6</strong><hr class='my-0'/>(2 + 6 = 8), (2 + 4 = 6), (4 + 5 = 9), (1 + 5 = 6), (3 + 5 = 8), (1 + 7 = 8)<br/></br/>"
        },
        'V3': {
          'LG': '75.0',
          'FGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 0</strong><hr class='my-0'/><br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 1</strong><hr class='my-0'/>(6 + 4 = 10)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 1</strong><hr class='my-0'/>(2 + 7 = 9)<br/></br/>",
          'LGM': '4',
          'RGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 6</strong><hr class='my-0'/>(2 + 1 = 3), (9 + 1 = 10), (4 + 1 = 5), (9 + 0 = 9), (3 + 1 = 4), (7 + 1 = 8)<br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 6</strong><hr class='my-0'/>(3 + 3 = 6), (7 + 3 = 10), (4 + 2 = 6), (4 + 4 = 8), (8 + 2 = 10), (4 + 3 = 7)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 6</strong><hr class='my-0'/>(2 + 6 = 8), (2 + 4 = 6), (4 + 5 = 9), (1 + 5 = 6), (3 + 5 = 8), (1 + 7 = 8)<br/></br/>",
          'SUM': 15
        }
      }

      report = {
        'trend': 1,
        'negative': %w[I62 I15 I64 I16 I05],
        'positive': %w[I36 I33 I18 I06 I27 I61 I53 I26 I07 I25 I55 I17 I28 I02 I04],
        'result_number': 4
      }

      data = [
        {
          'item': 'I62',
          'time': 12_656,
          'group': 3,
          'answer': '10',
          'result': 0,
          'description': '2 + 7 = 9'
        },
        {
          'item': 'I36',
          'time': 10_378,
          'group': 1,
          'answer': '3',
          'result': 1,
          'description': '2 + 1 = 3'
        },
        {
          'item': 'I33',
          'time': 10_278,
          'group': 2,
          'answer': '6',
          'result': 1,
          'description': '3 + 3 = 6'
        },
        {
          'item': 'I18',
          'time': 17_141,
          'group': 3,
          'answer': '8',
          'result': 1,
          'description': '2 + 6 = 8'
        },
        {
          'item': 'I15',
          'time': 39_283,
          'group': 2,
          'answer': '13',
          'result': 0,
          'description': '6 + 4 = 10'
        },
        {
          'item': 'I06',
          'time': 11_972,
          'group': 1,
          'answer': '10',
          'result': 1,
          'description': '9 + 1 = 10'
        },
        {
          'item': 'I27',
          'time': 37_913,
          'group': 2,
          'answer': '10',
          'result': 1,
          'description': '7 + 3 = 10'
        },
        {
          'item': 'I61',
          'time': 23_398,
          'group': 3,
          'answer': '6',
          'result': 1,
          'description': '2 + 4 = 6'
        },
        {
          'item': 'I53',
          'time': 7367,
          'group': 1,
          'answer': '5',
          'result': 1,
          'description': '4 + 1 = 5'
        },
        {
          'item': 'I26',
          'time': 7288,
          'group': 3,
          'answer': '9',
          'result': 1,
          'description': '4 + 5 = 9'
        },
        {
          'item': 'I07',
          'time': 14_818,
          'group': 2,
          'answer': '6',
          'result': 1,
          'description': '4 + 2 = 6'
        },
        {
          'item': 'I25',
          'time': 12_961,
          'group': 1,
          'answer': '9',
          'result': 1,
          'description': '9 + 0 = 9'
        },
        {
          'item': 'I55',
          'time': 18_056,
          'group': 3,
          'answer': '6',
          'result': 1,
          'description': '1 + 5 = 6'
        },
        {
          'item': 'I17',
          'time': 13_192,
          'group': 1,
          'answer': '4',
          'result': 1,
          'description': '3 + 1 = 4'
        },
        {
          'item': 'I28',
          'time': 6201,
          'group': 2,
          'answer': '8',
          'result': 1,
          'description': '4 + 4 = 8'
        },
        {
          'item': 'I02',
          'time': 8150,
          'group': 1,
          'answer': '8',
          'result': 1,
          'description': '7 + 1 = 8'
        },
        {
          'item': 'I04',
          'time': 12_124,
          'group': 3,
          'answer': '8',
          'result': 1,
          'description': '3 + 5 = 8'
        },
        {
          'item': 'I16',
          'time': 13_632,
          'group': 2,
          'answer': '11',
          'result': 0,
          'description': '8 + 2 = 10'
        },
        {
          'item': 'I05',
          'time': 17_335,
          'group': 2,
          'answer': '8',
          'result': 0,
          'description': '4 + 3 = 7'
        },
        {
          'item': 'I64',
          'time': 5861,
          'group': 3,
          'answer': '9',
          'result': 0,
          'description': '1 + 7 = 8'
        }
      ]

      test_date = '2025-02-09'
      id =
        Result.new(
          student_id: students[0],
          assessment_id: assessment_id,
          views: views,
          report: report,
          data: data,
          test_date: test_date
        )
      id.save(validate: false)

      test_date = '2025-02-02'
      id =
        Result.new(
          student_id: students[1],
          assessment_id: assessment_id,
          views: views,
          report: report,
          data: data,
          test_date: test_date
        )
      id.save(validate: false)

      views = {
        'V1': 12,
        'V2': {
          'LG': '60.0',
          'FGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 0</strong><hr class='my-0'/><br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 1</strong><hr class='my-0'/>(6 + 4 = 10)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 1</strong><hr class='my-0'/>(2 + 7 = 9)<br/></br/>",
          'LGM': '4',
          'RGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 6</strong><hr class='my-0'/>(2 + 1 = 3), (9 + 1 = 10), (4 + 1 = 5), (9 + 0 = 9), (3 + 1 = 4), (7 + 1 = 8)<br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 6</strong><hr class='my-0'/>(3 + 3 = 6), (7 + 3 = 10), (4 + 2 = 6), (4 + 4 = 8), (8 + 2 = 10), (4 + 3 = 7)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 6</strong><hr class='my-0'/>(2 + 6 = 8), (2 + 4 = 6), (4 + 5 = 9), (1 + 5 = 6), (3 + 5 = 8), (1 + 7 = 8)<br/></br/>"
        },
        'V3': {
          'LG': '60.0',
          'FGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 0</strong><hr class='my-0'/><br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 1</strong><hr class='my-0'/>(6 + 4 = 10)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 1</strong><hr class='my-0'/>(2 + 7 = 9)<br/></br/>",
          'LGM': '4',
          'RGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 6</strong><hr class='my-0'/>(2 + 1 = 3), (9 + 1 = 10), (4 + 1 = 5), (9 + 0 = 9), (3 + 1 = 4), (7 + 1 = 8)<br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 6</strong><hr class='my-0'/>(3 + 3 = 6), (7 + 3 = 10), (4 + 2 = 6), (4 + 4 = 8), (8 + 2 = 10), (4 + 3 = 7)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 6</strong><hr class='my-0'/>(2 + 6 = 8), (2 + 4 = 6), (4 + 5 = 9), (1 + 5 = 6), (3 + 5 = 8), (1 + 7 = 8)<br/></br/>",
          'SUM': 12
        }
      }

      report = {
        'trend': 1,
        'negative': %w[I62 I15 I64 I16 I05 I28 I02 I04],
        'positive': %w[I36 I33 I18 I06 I27 I61 I53 I26 I07 I25 I55 I17],
        'result_number': 4
      }

      data = [
        {
          'item': 'I62',
          'time': 12_656,
          'group': 3,
          'answer': '10',
          'result': 0,
          'description': '2 + 7 = 9'
        },
        {
          'item': 'I36',
          'time': 10_378,
          'group': 1,
          'answer': '3',
          'result': 1,
          'description': '2 + 1 = 3'
        },
        {
          'item': 'I33',
          'time': 10_278,
          'group': 2,
          'answer': '6',
          'result': 1,
          'description': '3 + 3 = 6'
        },
        {
          'item': 'I18',
          'time': 17_141,
          'group': 3,
          'answer': '8',
          'result': 1,
          'description': '2 + 6 = 8'
        },
        {
          'item': 'I15',
          'time': 39_283,
          'group': 2,
          'answer': '13',
          'result': 0,
          'description': '6 + 4 = 10'
        },
        {
          'item': 'I06',
          'time': 11_972,
          'group': 1,
          'answer': '10',
          'result': 1,
          'description': '9 + 1 = 10'
        },
        {
          'item': 'I27',
          'time': 37_913,
          'group': 2,
          'answer': '10',
          'result': 1,
          'description': '7 + 3 = 10'
        },
        {
          'item': 'I61',
          'time': 23_398,
          'group': 3,
          'answer': '6',
          'result': 1,
          'description': '2 + 4 = 6'
        },
        {
          'item': 'I53',
          'time': 7367,
          'group': 1,
          'answer': '5',
          'result': 1,
          'description': '4 + 1 = 5'
        },
        {
          'item': 'I26',
          'time': 7288,
          'group': 3,
          'answer': '9',
          'result': 1,
          'description': '4 + 5 = 9'
        },
        {
          'item': 'I07',
          'time': 14_818,
          'group': 2,
          'answer': '6',
          'result': 1,
          'description': '4 + 2 = 6'
        },
        {
          'item': 'I25',
          'time': 12_961,
          'group': 1,
          'answer': '9',
          'result': 1,
          'description': '9 + 0 = 9'
        },
        {
          'item': 'I55',
          'time': 18_056,
          'group': 3,
          'answer': '6',
          'result': 1,
          'description': '1 + 5 = 6'
        },
        {
          'item': 'I17',
          'time': 13_192,
          'group': 1,
          'answer': '4',
          'result': 1,
          'description': '3 + 1 = 4'
        },
        {
          'item': 'I28',
          'time': 6201,
          'group': 2,
          'answer': '4',
          'result': 0,
          'description': '4 + 4 = 8'
        },
        {
          'item': 'I02',
          'time': 8150,
          'group': 1,
          'answer': '10',
          'result': 0,
          'description': '7 + 1 = 8'
        },
        {
          'item': 'I04',
          'time': 12_124,
          'group': 3,
          'answer': '22',
          'result': 0,
          'description': '3 + 5 = 8'
        },
        {
          'item': 'I16',
          'time': 13_632,
          'group': 2,
          'answer': '11',
          'result': 0,
          'description': '8 + 2 = 10'
        },
        {
          'item': 'I05',
          'time': 17_335,
          'group': 2,
          'answer': '8',
          'result': 0,
          'description': '4 + 3 = 7'
        },
        {
          'item': 'I64',
          'time': 5861,
          'group': 3,
          'answer': '9',
          'result': 0,
          'description': '1 + 7 = 8'
        }
      ]

      test_date = '2025-02-02'
      id =
        Result.new(
          student_id: students[0],
          assessment_id: assessment_id,
          views: views,
          report: report,
          data: data,
          test_date: test_date
        )
      id.save(validate: false)

      test_date = '2025-02-09'
      id =
        Result.new(
          student_id: students[1],
          assessment_id: assessment_id,
          views: views,
          report: report,
          data: data,
          test_date: test_date
        )
      id.save(validate: false)

      views = {
        'V1': 8,
        'V2': {
          'LG': '40.0',
          'FGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 0</strong><hr class='my-0'/><br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 1</strong><hr class='my-0'/>(6 + 4 = 10)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 1</strong><hr class='my-0'/>(2 + 7 = 9)<br/></br/>",
          'LGM': '4',
          'RGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 6</strong><hr class='my-0'/>(2 + 1 = 3), (9 + 1 = 10), (4 + 1 = 5), (9 + 0 = 9), (3 + 1 = 4), (7 + 1 = 8)<br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 6</strong><hr class='my-0'/>(3 + 3 = 6), (7 + 3 = 10), (4 + 2 = 6), (4 + 4 = 8), (8 + 2 = 10), (4 + 3 = 7)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 6</strong><hr class='my-0'/>(2 + 6 = 8), (2 + 4 = 6), (4 + 5 = 9), (1 + 5 = 6), (3 + 5 = 8), (1 + 7 = 8)<br/></br/>"
        },
        'V3': {
          'LG': '40.0',
          'FGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 0</strong><hr class='my-0'/><br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 1</strong><hr class='my-0'/>(6 + 4 = 10)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 1</strong><hr class='my-0'/>(2 + 7 = 9)<br/></br/>",
          'LGM': '4',
          'RGI':
            "<strong>Addition (1. Summand ≥ 2. Summand; 2. Summand < 2):: 6</strong><hr class='my-0'/>(2 + 1 = 3), (9 + 1 = 10), (4 + 1 = 5), (9 + 0 = 9), (3 + 1 = 4), (7 + 1 = 8)<br/></br/><strong>Addition (1. Summand ≥ 2. Summand; 2. Summand ≥ 2):: 6</strong><hr class='my-0'/>(3 + 3 = 6), (7 + 3 = 10), (4 + 2 = 6), (4 + 4 = 8), (8 + 2 = 10), (4 + 3 = 7)<br/></br/><strong>Addition (1. Summand < 2. Summand;  2. Summand ≥ 2): 6</strong><hr class='my-0'/>(2 + 6 = 8), (2 + 4 = 6), (4 + 5 = 9), (1 + 5 = 6), (3 + 5 = 8), (1 + 7 = 8)<br/></br/>",
          'SUM': 8
        }
      }

      report = {
        'trend': 1,
        'negative': %w[I62 I15 I64 I16 I05 I28 I02 I04 I07 I25 I55 I17],
        'positive': %w[I36 I33 I18 I06 I27 I61 I53 I26],
        'result_number': 4
      }

      data = [
        {
          'item': 'I62',
          'time': 12_656,
          'group': 3,
          'answer': '10',
          'result': 0,
          'description': '2 + 7 = 9'
        },
        {
          'item': 'I36',
          'time': 10_378,
          'group': 1,
          'answer': '3',
          'result': 1,
          'description': '2 + 1 = 3'
        },
        {
          'item': 'I33',
          'time': 10_278,
          'group': 2,
          'answer': '6',
          'result': 1,
          'description': '3 + 3 = 6'
        },
        {
          'item': 'I18',
          'time': 17_141,
          'group': 3,
          'answer': '8',
          'result': 1,
          'description': '2 + 6 = 8'
        },
        {
          'item': 'I15',
          'time': 39_283,
          'group': 2,
          'answer': '13',
          'result': 0,
          'description': '6 + 4 = 10'
        },
        {
          'item': 'I06',
          'time': 11_972,
          'group': 1,
          'answer': '10',
          'result': 1,
          'description': '9 + 1 = 10'
        },
        {
          'item': 'I27',
          'time': 37_913,
          'group': 2,
          'answer': '10',
          'result': 1,
          'description': '7 + 3 = 10'
        },
        {
          'item': 'I61',
          'time': 23_398,
          'group': 3,
          'answer': '6',
          'result': 1,
          'description': '2 + 4 = 6'
        },
        {
          'item': 'I53',
          'time': 7367,
          'group': 1,
          'answer': '5',
          'result': 1,
          'description': '4 + 1 = 5'
        },
        {
          'item': 'I26',
          'time': 7288,
          'group': 3,
          'answer': '9',
          'result': 1,
          'description': '4 + 5 = 9'
        },
        {
          'item': 'I07',
          'time': 14_818,
          'group': 2,
          'answer': '8',
          'result': 0,
          'description': '4 + 2 = 6'
        },
        {
          'item': 'I25',
          'time': 12_961,
          'group': 1,
          'answer': '90',
          'result': 0,
          'description': '9 + 0 = 9'
        },
        {
          'item': 'I55',
          'time': 18_056,
          'group': 3,
          'answer': '2',
          'result': 0,
          'description': '1 + 5 = 6'
        },
        {
          'item': 'I17',
          'time': 13_192,
          'group': 1,
          'answer': '5',
          'result': 0,
          'description': '3 + 1 = 4'
        },
        {
          'item': 'I28',
          'time': 6201,
          'group': 2,
          'answer': '4',
          'result': 0,
          'description': '4 + 4 = 8'
        },
        {
          'item': 'I02',
          'time': 8150,
          'group': 1,
          'answer': '10',
          'result': 0,
          'description': '7 + 1 = 8'
        },
        {
          'item': 'I04',
          'time': 12_124,
          'group': 3,
          'answer': '22',
          'result': 0,
          'description': '3 + 5 = 8'
        },
        {
          'item': 'I16',
          'time': 13_632,
          'group': 2,
          'answer': '11',
          'result': 0,
          'description': '8 + 2 = 10'
        },
        {
          'item': 'I05',
          'time': 17_335,
          'group': 2,
          'answer': '8',
          'result': 0,
          'description': '4 + 3 = 7'
        },
        {
          'item': 'I64',
          'time': 5861,
          'group': 3,
          'answer': '9',
          'result': 0,
          'description': '1 + 7 = 8'
        }
      ]

      test_date = '2025-01-26'
      id =
        Result.new(
          student_id: students[0],
          assessment_id: assessment_id,
          views: views,
          report: report,
          data: data,
          test_date: test_date
        )
      id.save(validate: false)

      test_date = '2025-02-18'
      id =
        Result.new(
          student_id: students[1],
          assessment_id: assessment_id,
          views: views,
          report: report,
          data: data,
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
