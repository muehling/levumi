class AnnotationCategoriesController < ApplicationController
  def index
    @annotation_categories = News.all
    render json: @annotation_categories
  end

  def create
    @news = News.new(annotation_categories_attributes)
    if @news.save
      render json: @news
    else
      render json: {
               message: "news_controller::create: record couldn't be created"
             },
             status: :unprocessable_entity
    end
  end

  def destroy
    News.destroy(params[:id])
    head :ok
  end

  private

  def annotation_categories_attributes
    params.permit(:id, :date, :title, :message)
  end
end
