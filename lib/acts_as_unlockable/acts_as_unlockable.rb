require 'active_record'

module Acts #:nodoc:
  module Unlockable #:nodoc:
  extend ActiveSupport::Concern

  module ClassMethods
    def acts_as_unlockable
      has_many :unlocks, :class_name => "Unlock", :as => :unlockable, :dependent => :destroy
      
      include Acts::Unlockable::LocalInstanceMethods
      extend Acts::Unlockable::SingletonMethods
    end
  end
    
  # This module contains class methods
  module SingletonMethods
    
  end
  
  module LocalInstanceMethods
    def unlock(unlocker)
      self.unlocks.create!(:unlocker => unlocker) unless unlocked?(unlocker)
    end
    
    def unlocked?(unlocker)
      !self.unlocks.find_by_unlocker_id_and_unlocker_type(unlocker.id, unlocker.class.name).nil?
    end
  end
    
  end
end

ActiveRecord::Base.send(:include, Acts::Unlockable)
