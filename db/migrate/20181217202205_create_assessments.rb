class CreateAssessments < ActiveRecord::Migration[5.2]
  def change
    create_table :assessments do |t|
      t.integer :group_id
      t.integer :test_id

      t.timestamps
    end
  end
end
