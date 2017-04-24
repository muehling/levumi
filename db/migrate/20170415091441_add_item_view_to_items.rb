#TODO Ggf. mit Data zusammenfassen
class AddItemViewToItems < ActiveRecord::Migration
  def change
    add_column :items, :itemview, :text
  end
end
