class CreateTests < ActiveRecord::Migration
  def change
    create_table :tests do |t|
      t.text :name
      t.text :info

      t.timestamps
    end
  end
end
