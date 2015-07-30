class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.integer :group_id
      t.integer :test_id

      t.timestamps
    end
  end
end
