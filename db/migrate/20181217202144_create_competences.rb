class CreateCompetences < ActiveRecord::Migration[5.2]
  def change
    create_table :competences do |t|
      t.string :name
      t.string :description
      t.belongs_to :area, index: true, foreign_key: {on_delete: :cascade}

      t.timestamps
    end
  end
end
