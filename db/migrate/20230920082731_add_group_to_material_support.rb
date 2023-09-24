class AddGroupToMaterialSupport < ActiveRecord::Migration[7.0]
  def change
    add_column :material_supports, :group, :integer
  end
end
