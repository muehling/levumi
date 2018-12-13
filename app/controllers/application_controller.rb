class ApplicationController < ActionController::Base
  before_action :set_user

  private
  #Auto Log-In zum Entwickeln
  def set_user
    @user = User.find(1)
  end
end
