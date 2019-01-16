class CreateTestFamilies < ActiveRecord::Migration[5.2]
  def change
    create_table :test_families do |t|
      t.string :name
      t.string :description
      t.integer :competence_id

      t.timestamps
    end
  end
end
