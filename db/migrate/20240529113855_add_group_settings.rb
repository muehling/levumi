class AddGroupSettings < ActiveRecord::Migration[7.0]
  def change
    add_column :groups, :settings, :json
  end
end
