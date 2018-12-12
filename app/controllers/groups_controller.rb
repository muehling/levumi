class GroupsController < ApplicationController

  def index
    @groups = User.find(1).groups.all
  end
end
