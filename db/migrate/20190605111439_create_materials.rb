class CreateMaterials < ActiveRecord::Migration[5.2]
  def change
    create_table :materials do |t|
      t.string :name
      t.text :description
      t.timestamps
    end

    create_table :material_supports do |t|
      t.belongs_to :material, index: true
      t.belongs_to :area, index: true
      t.belongs_to :competence, index: true
      t.belongs_to :test_family, index: true
      t.belongs_to :test, index: true
      t.text :items
      t.timestamps
    end
  end
end
