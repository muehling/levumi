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

  def destroy
    annotations = Annotation.where(annotation_category_id: params[:id])
    if annotations.empty?
      AnnotationCategory.destroy(params[:id])
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def annotation_categories_attributes
    params.permit(:name, :id)
  end
end
