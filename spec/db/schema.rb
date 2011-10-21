ActiveRecord::Schema.define(:version => 1) do
  create_table "users", :force => true do |t|
    t.timestamps
  end
  
  create_table "guests", :force => true do |t|
    t.timestamps
  end
  
  create_table "publications", :force => true do |t|
    t.timestamps
  end
  
  create_table "admin_publications", :force => true do |t|
    t.timestamps
  end
  
  create_table "videos", :force => true do |t|
    t.timestamps
  end

  create_table "unlocks", :force => true do |t|
    t.integer :unlockable_id, :null => false
    t.string :unlockable_type, :null => false
    t.integer :unlocker_id, :null => false
    t.string :unlocker_type,:null => false
    t.timestamps
  end
  
  create_table "unlock_limits", :force => true do |t|
    t.string :unlockable_type
    t.integer :unlocker_id, :null => false
    t.string :unlocker_type, :null => false
    t.integer :limit, :null => false
    t.timestamps
  end

  add_index "unlocks", "unlocker_id"
  add_index "unlocks", "unlockable_id"
  add_index "unlock_limits", "unlocker_id"
end
