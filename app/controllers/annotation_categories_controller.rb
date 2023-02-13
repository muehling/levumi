class AnnotationCategoriesController < ApplicationController
  def index
    @annotation_categories = AnnotationCategory.all
    render json: @annotation_categories, only: %i[id name]
  end

  def create
    @annotation_category = AnnotationCategory.new(annotation_categories_attributes)
    if @annotation_category.save
      render json: @annotation_category, only: %i[id name]
    else
      head :unprocessable_entity
    end
  end

  def destroy; end

  private

  def annotation_categories_attributes
    params.permit(:name)
  end
end
