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
      t.belongs_to :area, index: true, foreign_key: {on_delete: :cascade}

      t.timestamps
    end

    create_table :test_families do |t|
      t.string :name
      t.text :description
      t.belongs_to :competence, index: true, foreign_key: {on_delete: :cascade}

      t.timestamps
    end

    create_table :tests do |t|
      t.belongs_to :test_family, index: true, foreign_key: {on_delete: :cascade}
      t.string :level
      t.string :shorthand
      t.text :full_description
      t.text :short_description
      t.boolean :student_test
      t.boolean :archive, default: false
      t.text :configuration
      t.timestamps
    end

    create_table :items do |t|
      t.belongs_to :test, index: true, foreign_key: {on_delete: :cascade}
      t.string :shorthand
      t.string :description
      t.timestamps
    end
  end
end
