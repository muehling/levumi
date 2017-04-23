class AddItemViewToItems < ActiveRecord::Migration
  def change
    add_column :items, :itemview, :text
  end
end
