class AddStudentAccessToTest < ActiveRecord::Migration
  def change
    add_column :tests, :student_access, :boolean
  end
end
