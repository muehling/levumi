# -*- encoding : utf-8 -*-
class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.text :firstname
      t.text :name
      t.integer :group_id

      t.timestamps
    end
  end
end
