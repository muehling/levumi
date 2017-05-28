class AddTcAcceptToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tcaccept, :datetime
  end
end
