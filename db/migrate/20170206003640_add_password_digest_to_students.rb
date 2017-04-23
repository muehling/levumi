class AddPasswordDigestToStudents < ActiveRecord::Migration
  def change
    add_column :students, :password_digest, :text
  end
end
