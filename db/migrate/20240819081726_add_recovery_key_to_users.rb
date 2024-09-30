class AddRecoveryKeyToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :recovery_key, :string
  end
end
