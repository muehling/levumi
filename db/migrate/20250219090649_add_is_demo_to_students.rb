class AddIsDemoToStudents < ActiveRecord::Migration[7.2]
  def change
    add_column :students, :is_demo, :boolean
  end
end
