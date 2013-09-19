class CreateAvails < ActiveRecord::Migration
  def change
    create_table :avails do |t|
      t.references :player, :index => true
      t.string :day
      t.integer :time

      t.timestamps
    end
    
    add_index :avails, :player_id
    
  end
end
