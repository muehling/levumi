class AddExtraDataToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :state, :integer
    add_column :users, :occupation, :integer
  end
end
