class TestsController < ApplicationController
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
          Test.import(f.tempfile, !params.has_key?(:update_test), params.has_key?(:update_material))
            .nil?
      if @import_failure
        head :unprocessable_entity
      else
        head :ok
      end
    end
  end

  #PUT /tests/:id
  def update
    render nothing: true if !@test.update(test_attributes)
  end

  #DEL /tests/:id
  def destroy
    id = @test.test_family.id
    @test.destroy
    family = TestFamily.find(id)
    family.destroy if family.tests.empty?
    head :ok
  end

  def get_tests_data
    @data = Area.includes(competences: [{ test_families: [:tests] }]).all
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
    all_families =
      TestFamily.all.map do |family|
        {
          test_count: Test.where(test_family_id: family.id).count,
          id: family.id,
          name: family.name,
          competence_id: family.competence_id
        }
      end
    all_competences =
      Competence.all.map do |competence|
        {
          test_count:
            all_families
              .select { |family| family[:competence_id] == competence.id }
              .reduce(0) { |sum, family| sum + family[:test_count] },
          name: competence.name,
          id: competence.id,
          area_id: competence.area_id
        }
      end
    all_areas =
      Area.all.map do |area|
        {
          test_count:
            all_competences
              .select { |competence| competence[:area_id] == area.id }
              .reduce(0) { |sum, competence| sum + competence[:test_count] },
          name: area.name,
          id: area.id
        }
      end

    render json: {
             areas: all_areas,
             test_families: all_families,
             competences: all_competences,
             tests: Test.all
           }
  end

  private

  #Erlaubte Attribute definieren
  def test_attributes
    params.require(:test).permit(description: %i[full short])
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
