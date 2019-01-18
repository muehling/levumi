class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.belongs_to :student, index: true, foreign_key: true
      t.belongs_to :assessment, index: true, foreign_key: true
      t.references :prior_result
      t.string :data

      t.timestamps
    end
  end
end
