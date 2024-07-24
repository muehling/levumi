class AddNewsToDatabase < ActiveRecord::Migration[7.1]
  def change
    create_table :news do |t|
      t.date :date
      t.string :title
      t.text :message
      t.timestamps
    end
  end
end
