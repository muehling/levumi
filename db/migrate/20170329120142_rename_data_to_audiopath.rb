#TODO Lieber generisch!

class RenameDataToAudiopath < ActiveRecord::Migration
  def change
    rename_column :items, :data, :audiopath
  end
end
