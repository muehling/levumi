class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.string :name
      t.string :login
      t.integer :group_id
      t.timestamps
    end
  end
end
