# -*- encoding : utf-8 -*-
class AddArchiveToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :archive, :boolean
  end
end
