class CreateAnnotations < ActiveRecord::Migration[5.2]
  def change
    create_table :annotations do |t|
      t.belongs_to :assessment, index: true
      t.belongs_to :student
      t.belongs_to :group
      t.integer :view
      t.text :content
      t.date :start
      t.date :end
      t.timestamps
    end
  end
end
