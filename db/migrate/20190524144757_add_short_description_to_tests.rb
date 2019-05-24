class AddShortDescriptionToTests < ActiveRecord::Migration[5.2]
  def change
    add_column :tests, :short_description, :text
  end
end
