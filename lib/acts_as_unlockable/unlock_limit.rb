class UnlockLimit < ActiveRecord::Base
  belongs_to :unlocker, :polymorphic => true
end
