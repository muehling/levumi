class AddCategoryToTests < ActiveRecord::Migration
  def change
    add_column :tests, :category, :text
  end
end
