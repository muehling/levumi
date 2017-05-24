# -*- encoding : utf-8 -*-
class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :test_id
      t.text :shorthand
      t.text :itemtext
      t.integer :difficulty

      t.timestamps
    end
  end
end
