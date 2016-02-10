class RenameCategoryToConstruct < ActiveRecord::Migration
  def change
    rename_column :tests, :category, :construct
  end
end
