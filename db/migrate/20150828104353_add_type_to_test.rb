class AddTypeToTest < ActiveRecord::Migration
  def change
    add_column :tests, :type, :text
  end
end
