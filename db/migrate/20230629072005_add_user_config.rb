class AddUserConfig < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :settings, :json
  end
end
