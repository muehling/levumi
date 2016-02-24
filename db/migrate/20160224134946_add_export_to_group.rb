class AddExportToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :export, :boolean
  end
end
