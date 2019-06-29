class CreateAssessments < ActiveRecord::Migration[5.2]
  def change
    create_table :assessments do |t|
      t.belongs_to :group, index: true
      t.belongs_to :test, index: true

      t.timestamps
    end
  end
end
