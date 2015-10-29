class AddSubjectToTest < ActiveRecord::Migration
  def change
    add_column :tests, :subject, :text
  end
end
