class CreateMaterials < ActiveRecord::Migration[5.0]
  def change
    create_table :materials do |t|
      t.text :subject
      t.text :construct
      t.text :block
      t.text :exercisetype
      t.text :blockinfo
      t.text :exerciseinfo
      t.text :data
      t.timestamps
    end
  end
end
