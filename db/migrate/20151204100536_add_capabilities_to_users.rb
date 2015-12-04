class AddCapabilitiesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :capabilities, :text
  end
end
