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
      head :unprocessable_entity
    end
  end

  def destroy
    tests = Test.where(test_type_id: params[:id])
    if tests.empty? && params[:id] != 1
      TestType.destroy(params[:id])
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def test_types_attributes
    params.permit(:name, :description, :id)
  end
end
