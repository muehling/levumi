class CreateCompetences < ActiveRecord::Migration[5.2]
  def change
    create_table :competences do |t|
      t.string :name
      t.string :description
      t.integer :area_id

      t.timestamps
    end
  end
end
