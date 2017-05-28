class RemoveFirstnameFromStudents < ActiveRecord::Migration
  def change
    remove_column :students, :firstname
  end
end
