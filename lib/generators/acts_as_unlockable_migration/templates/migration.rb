class ActsAsUnlockableMigration < ActiveRecord::Migration
  def self.up
    create_table :unlocks, :force => true do |t|
      t.integer :unlockable_id, :default => 0, :null => false
      t.string :unlockable_type, :default => ""
      t.integer :unlocker_id, :default => 0, :null => false
      t.string :unlocker_type, :default => ""
      t.timestamps
    end
    
    add_index :unlocks, :unlocker_id
    add_index :unlocks, :unlockable_id
  end
  
  def self.down
    drop_table :unlocks
  end
end