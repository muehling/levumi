class AddGenericViewsToTests < ActiveRecord::Migration[5.0]
  def change
    add_column :tests, :generic_views, :text
  end
end
