require 'active_record'

module Acts #:nodoc:
  module Unlocker #:nodoc:
  extend ActiveSupport::Concern

  module ClassMethods
    def acts_as_unlocker
      has_many :unlocks, :class_name => "Unlock", :as => :unlocker, :dependent => :destroy
      
      include Acts::Unlocker::LocalInstanceMethods
      extend Acts::Unlocker::SingletonMethods
    end
  end
    
  # This module contains class methods
  module SingletonMethods
    
  end
  
  module LocalInstanceMethods
    def unlock(unlockable)
      self.unlocks.create!(:unlockable => unlockable) unless self.has_unlocked?(unlockable)
    end
    
    def has_unlocked?(unlockable)
      !self.unlocks.find_by_unlockable_id_and_unlockable_type(unlockable.id, unlockable.class.name).nil?
    end
  end
    
  end
end

ActiveRecord::Base.send(:include, Acts::Unlocker)
