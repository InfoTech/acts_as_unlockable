class Unlock < ActiveRecord::Base
  belongs_to :unlocker, :polymorphic => true
  belongs_to :unlockable, :polymorphic => true
  
end
