class NewsController < ApplicationController
  def index
    @news = News.all
    render json: @news
  end

  def create
    @news = News.new(news_attributes)
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

  def news_attributes
    params.permit(:id, :date, :title, :message)
  end
end
