class AddBasicStudentInfoToStudents < ActiveRecord::Migration
  def change
    add_column :students, :birthdate, :date
    add_column :students, :gender, :boolean
  end
end
