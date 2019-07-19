class AddTransferredToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :transferred, :boolean
  end
end
