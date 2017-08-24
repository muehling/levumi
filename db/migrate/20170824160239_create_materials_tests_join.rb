class CreateMaterialsTestsJoin < ActiveRecord::Migration[5.0]
  def change
    create_table :materials_tests_joins, :id => false do |t|
      t.column 'material_id', :integer
      t.column 'test_id', :integer
    end
  end
end
