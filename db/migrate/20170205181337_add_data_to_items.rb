class AddDataToItems < ActiveRecord::Migration
  def change
    add_column :items, :mediapath, :text
    add_column :items, :itemview, :text
    add_column :items, :itemtype, :integer
  end
end
