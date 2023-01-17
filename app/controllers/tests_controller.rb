class TestsController < ApplicationController
  before_action :set_test, except: %i[index create get_tests_data]
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
    #if params[:admin] && @login.has_capability?('test')
    #  render 'index_admin'
    #else
    #  if params[:export] && @login.has_capability?('export')
    #    render 'index_export'
    #  else
    #    render 'index'
    #  end
    #end
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
