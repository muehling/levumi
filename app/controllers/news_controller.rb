class NewsController < ApplicationController
  def index
    @news = News.all
    render json: @news
  end

  def create
    @news = News.new(news_attributes)
    @news.date = Date.today
    if @news.save
      render json: @news
    else
      render json: {
               message: "news_controller::create: record couldn't be created"
             },
             status: :unprocessable_entity
    end
  end

  def update
    news = News.find(params[:id])
    news.update(news_attributes)
  end

  def destroy
    News.destroy(params[:id])
    render json: News.all, status: :ok
  end

  private

  def news_attributes
    params.require(:news).permit(:id, :date, :title, :message)
  end
end
