class AddTypeInfoToTests < ActiveRecord::Migration[5.0]
  def change
    add_column :tests, :type_info, :text
  end
end
