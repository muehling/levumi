class AddLoginToStudents < ActiveRecord::Migration
  def change
    add_column :students, :login, :text
  end
end
