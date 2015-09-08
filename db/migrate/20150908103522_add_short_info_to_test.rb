class AddShortInfoToTest < ActiveRecord::Migration
  def change
    add_column :tests, :short_info, :text
  end
end
