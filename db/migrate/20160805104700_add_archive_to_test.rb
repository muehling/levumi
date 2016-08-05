class AddArchiveToTest < ActiveRecord::Migration
  def change
    add_column :tests, :archive, :boolean
  end
end
