class AddRemovedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :removed, :boolean
  end
end
