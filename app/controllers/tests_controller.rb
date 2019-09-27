class TestsController < ApplicationController
  before_action :set_test, except: [:index, :create]
  before_action :is_allowed, only: [:create, :edit, :update, :destroy]

  #GET /tests
  def index
    if params[:admin] && @login.has_capability?('test')
      render 'index_admin'
    else
      if params[:export] && @login.has_capability?('export')
        render 'index_export'
      else
        render 'index'
      end
    end
  end

  #GET /tests/:id/edit
  def edit
  end

  #GET /test/:id
  def show
    #TODO: Sicherheitscheck ob erlaubt?
    send_data @test.as_csv, filename: @test.shorthand + '_' + DateTime.now.strftime("%Y_%m_%d") + '.csv' , type: :text
  end

  #POST /tests
  def create
    if params.has_key?(:test) && !params[:test][:file].nil?
      params[:test][:file].each do |f|
        @import_failure = Test.import(f.tempfile, !params.has_key?(:update_test), params.has_key?(:update_material)).nil?
      end
      render 'index_admin'
    end
  end

  #PUT /tests/:id
  def update
    if !@test.update_attributes(test_attributes)
      render nothing: true
    else
      render 'update'
    end
  end

  #DEL /tests/:id
  def destroy
    id = @test.test_family.id
    @test.destroy
    family = TestFamily.find(id)
    if family.tests.empty?
      family.destroy
    end
    render 'index_admin'
  end

  private

  #Erlaubte Attribute definieren
  def test_attributes
    params.require(:test).permit(description: [:full, :short])
  end

  #Prüfen ob Nutzer die Berechtigung für Testaktualisierungen hat
  def is_allowed
    unless @login.has_capability?('test')
      redirect_to '/'
    end
  end

  #Test laden
  def set_test
    @test = Test.find(params[:id])
  end

end
