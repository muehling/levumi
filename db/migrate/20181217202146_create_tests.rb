class CreateTests < ActiveRecord::Migration[5.2]
  def change
    create_table :tests do |t|
      t.belongs_to :test_family, index: true, foreign_key: {on_delete: :cascade}
      t.string :level
      t.string :shorthand
      t.text :description
      t.boolean :student_test
      t.boolean :archive, default: false
      t.text :configuration
      t.timestamps
    end
  end
end
