class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.belongs_to :student, index: true, foreign_key: true
      t.belongs_to :assessment, index: true, foreign_key: {on_delete: :cascade}
      t.references :prior_result
      t.date :test_date
      t.date :test_week
      t.date :expires_on
      t.string :data

      t.timestamps
    end
  end
end
