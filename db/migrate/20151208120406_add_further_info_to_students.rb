class AddFurtherInfoToStudents < ActiveRecord::Migration
  def change
    add_column :students, :specific_needs, :integer
    add_column :students, :migration, :boolean
  end
end
