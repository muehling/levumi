class CreateTestFamilies < ActiveRecord::Migration[5.2]
  def change
    create_table :test_families do |t|
      t.string :name
      t.string :description
      t.belongs_to :competence, index: true, foreign_key: {on_delete: :cascade}

      t.timestamps
    end
  end
end
