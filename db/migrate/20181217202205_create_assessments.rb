class CreateAssessments < ActiveRecord::Migration[5.2]
  def change
    create_table :assessments do |t|
      t.belongs_to :group, index: true, foreign_key: true
      t.belongs_to :test, index: true, foreign_key: true

      t.timestamps
    end
  end
end
