class TestsController < ApplicationController

  # GET /tests
  def index
    @tests = Test.all
  end

end
