class CreateTestHierarchy < ActiveRecord::Migration[5.2]
  def change
    create_table :areas do |t|
      t.string :name
      t.string :color
      t.timestamps
    end

    create_table :competences do |t|
      t.string :name
      t.text :description
      t.belongs_to :area, index: true
      t.timestamps
    end

    create_table :test_families do |t|
      t.string :name
      t.text :description
      t.belongs_to :competence, index: true
      t.timestamps
    end

    create_table :tests do |t|
      t.belongs_to :test_family, index: true
      t.string :level
      t.string :shorthand
      t.text :description
      t.boolean :student_test
      t.boolean :archive, default: false
      t.text :configuration, limit: 16777215
      t.text :items, limit: 16777215
      t.timestamps
    end
  end
end
