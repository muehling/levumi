class TestsController < ApplicationController
  skip_before_action :set_login, only: [:get_tests_data]
  before_action :set_test,
                except: %i[index create get_tests_data get_tests_meta check_upload_version]
  before_action :is_allowed, only: %i[create edit update destroy]

  #GET /tests
  def index
    #TODO check where which params are used.
    @all_tests =
      Test.all.sort_by do |t|
        [
          t.test_family.competence.area.id,
          t.test_family.competence.id,
          t.test_family.id,
          t.shorthand,
          t.version
        ]
      end
    if params[:show_export] && @login.has_capability?('export')
      render 'index'
    elsif @login.has_capability?('test')
      render 'list'
    end
  end

  #GET /tests/:id/edit
  def edit; end

  #GET /test/:id
  def show
    #TODO: Sicherheitscheck ob erlaubt?
    send_data @test.as_csv,
              filename: @test.shorthand + '_' + DateTime.now.strftime('%Y_%m_%d') + '.csv',
              type: :csv
  end

  #POST /tests
  def create
    if params.has_key?(:test) && !params[:test][:file].nil?
      f = params[:test][:file]
      @import_failure =
        !f.present? ||
          Test.import(
            f.tempfile,
            !params.has_key?(:update_test),
            params.has_key?(:update_material),
            @login
          ).nil?
      if @import_failure
        render json: {
                 message: 'tests_controller::create: test could not be imported from zip'
               },
               status: :unprocessable_entity
      else
        head :ok
      end
    end
  end

  #PUT /tests/:id
  def update
    if @test.update(test_attributes)
      head :ok
    else
      render json: {
               message: 'tests_controller::update: test could not be updated'
             },
             status: :unprocessable_entity
    end
  end

  #DEL /tests/:id
  def destroy
    if !@login.has_capability('test') || !@login.has_capability('test_admin')
      render json: { message: 'tests_controller::delete: not permitted' }, status: :forbidden and
        return
    end

    id = @test.test_family.id
    @test.destroy
    family = TestFamily.find(id)
    family.destroy if family.tests.empty? # TBD: seems a bit dangerous, as there might still be materials belonging to this family
    head :ok
  end

  def get_tests_data
    @data = Area.includes(competences: [{ test_families: [:tests] }]).all
  end

  def get_items
    if @test
      render json: @test.items
    else
      render json: {}
    end
  end

  def check_upload_version
    old_test = Test.where(shorthand: params[:shorthand]).where.not(archive: true).first
    if old_test.nil?
      is_new_version = false
    else
      is_new_version = old_test.version < params[:version]
    end

    render json: { is_new_version: is_new_version, is_new_test: old_test.nil? }
  end

  def get_tests_meta
    render json: Test.tests_meta
  end

  private

  #Erlaubte Attribute definieren
  def test_attributes
    params.require(:test).permit(:test_type_id, description: %i[full short])
  end

  #Prüfen ob Nutzer die Berechtigung für Testaktualisierungen hat
  def is_allowed
    redirect_to '/' unless @login.has_capability?('test')
  end

  #Test laden
  def set_test
    @test = Test.find(params[:id])
  end
end
