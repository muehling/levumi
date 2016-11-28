class AddExtraDataToResults < ActiveRecord::Migration
  def change
    add_column :results, :extra_data, :text
  end
end
