class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.string :name
      t.string :login
      t.belongs_to :group, index: true, foreign_key: true
      t.timestamps
    end
  end
end
