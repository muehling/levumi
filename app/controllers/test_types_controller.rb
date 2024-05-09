class TestTypesController < ApplicationController
  def index
    @test_types = TestType.all
    render json: @test_types, only: %i[id name description]
  end

  def create
    @type = TestType.new(test_types_attributes)
    if @type.save
      render json: @type, only: %i[id name description]
    else
      render json: {
               message: 'test_types_controller::create: test_type could not be created'
             },
             status: :unprocessable_entity
    end
  end

  def destroy
    tests = Test.where(test_type_id: params[:id])
    if tests.empty? && params[:id] != 1
      TestType.destroy(params[:id])
      head :ok
    else
      render json: {
               message: 'test_types_controller::destroy: test_type could not be found'
             },
             status: :not_found
    end
  end

  private

  def test_types_attributes
    params.permit(:name, :description, :id)
  end
end
