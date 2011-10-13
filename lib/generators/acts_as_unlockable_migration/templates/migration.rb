class ActsAsUnlockableMigration < ActiveRecord::Migration
  def self.up
    create_table :unlocks, :force => true do |t|
      t.integer :unlockable_id, :null => false
      t.string :unlockable_type, :null => false
      t.integer :unlocker_id, :null => false
      t.string :unlocker_type, :null => false
      t.timestamps
    end
    
    create_table :unlock_limits, :force => true do |t|
      t.string :unlockable_type
      t.integer :unlocker_id, :null => false
      t.string :unlocker_type, :null => false
      t.integer :limit, :null => false
      t.timestamps
    end

    add_index :unlock_limits, :unlocker_id
    add_index :unlocks, :unlocker_id
    add_index :unlocks, :unlockable_id
  end
  
  def self.down
    drop_table :unlocks
    drop_table :unlock_limits
  end
end
