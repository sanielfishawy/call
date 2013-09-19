class CreateAvails < ActiveRecord::Migration
  def change
    create_table :avails do |t|
      t.references :player
      t.string :day
      t.integer :time

      t.timestamps
    end
        
  end
end
