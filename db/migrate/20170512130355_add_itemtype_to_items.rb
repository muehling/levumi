class AddItemtypeToItems < ActiveRecord::Migration
  def change
    add_column :items, :itemtype, :integer
  end
end
