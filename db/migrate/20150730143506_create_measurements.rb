# -*- encoding : utf-8 -*-
class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.integer :assessment_id
      t.datetime :date

      t.timestamps
    end
  end
end
