class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.string :name
      t.string :login
      t.belongs_to :group, index: true, foreign_key: {on_delete: :cascade}
      t.integer :gender
      t.date :birthmonth
      t.integer :sen
      t.boolean :migration
      t.string :settings
      t.timestamps
    end
  end
end
