class TestsController < ApplicationController

  #GET /tests
  def index
  end


  def create
    if params.has_key?(:test) && !params[:test][:file].nil?
      res = true
      params[:test][:file].each do |f|
        res = res && Test.import(f.tempfile, params.has_key?(:archive), params.has_key?(:create)).nil?
      end
      render 'index'
    end
  end

end
