class AddMasterkeyToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :masterkey, :string
  end
end
