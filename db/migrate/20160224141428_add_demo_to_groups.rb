class AddDemoToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :demo, :boolean
  end
end
