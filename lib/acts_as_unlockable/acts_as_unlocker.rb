require 'active_record'

module Acts #:nodoc:
  module Unlocker #:nodoc:
  extend ActiveSupport::Concern

  module ClassMethods
    def acts_as_unlocker(options = {})
      has_many :unlocks, :class_name => "Unlock", :as => :unlocker, :dependent => :destroy
      has_many :unlock_limits, -> { where('unlockable_type IS NOT NULL') }, :class_name => "UnlockLimit", :as => :unlocker, :dependent => :destroy
      has_one :global_unlock_limit, -> { where('unlockable_type IS NULL') }, :class_name => "UnlockLimit", :as => :unlocker, :dependent => :destroy
      
      cattr_accessor :limits
      self.limits = options[:limits] || {}
      
      cattr_accessor :infinity
      self.infinity = 1.0/0
      
      include Acts::Unlocker::LocalInstanceMethods
      extend Acts::Unlocker::SingletonMethods
    end
  end
    
  # This module contains class methods
  module SingletonMethods
    
  end
  
  module LocalInstanceMethods
    def unlock(unlockable)
      raise UnlockLimitReached unless can_unlock?(unlockable)
      return false if has_unlocked?(unlockable)

      self.unlocks.create!(:unlockable => unlockable)
      return true
    end
    
    def has_unlocked?(unlockable)
      !self.unlocks.find_by_unlockable_id_and_unlockable_type(unlockable.id, unlockable.class.name).nil?
    end
    
    def max_unlocks=(value)
      limit = self.global_unlock_limit || UnlockLimit.new
      limit.limit = value
      self.global_unlock_limit = limit
    end
    
    def max_unlocks()
      self.global_unlock_limit.nil? ? nil : self.global_unlock_limit.limit
    end
    
    def can_unlock?(unlockable)
      return false if self.unlocks.count >= global_limit
    
      if unlock_limit(unlockable) < global_limit
        return self.unlocks.where(:unlockable_type => unlockable.class.name).count < unlock_limit(unlockable)    
      else
        return self.unlocks.where(:unlockable_type => unlockable.class.name).count < global_limit
      end
    end
    
    def global_limit
      unless global_unlock_limit.nil?
        return global_unlock_limit.limit 
      else 
        return limits[:global] || self.infinity
      end
    end
    
    def unlock_limit(unlockable)
      type = unlockable.is_a?(String) ? unlockable : unlockable.class.name
      
      unless self.unlock_limits.find_by_unlockable_type(type).nil?
        return self.unlock_limits.find_by_unlockable_type(type).limit
      end
      return limits[type.underscore.gsub('/', '__').to_sym] || self.infinity
    end
    
    def unlocks_remaining
      return global_limit - self.unlocks.count
    end
    
    def unlocks_remaining?
      return unlocks_remaining > 0
    end
    
    def unlocks_remaining_for_type(type)
      global_remaining = global_limit - self.unlocks.count
      remaining = unlock_limit(type) - self.unlocks.where(:unlockable_type => type).count  
      return [global_remaining, remaining].min
    end
    
    def max_unlocks_for(type, value)
      limit = self.unlock_limits.find_by_unlockable_type(type) || UnlockLimit.new(:unlockable_type => type)
      limit.limit = value
      self.unlock_limits << limit
    end
    
    def method_missing(method, *args, &block)
      class_name = method.to_s.gsub(/^max_unlocks_for_/, '').gsub(/\W/, '').gsub('__', '::_').camelize
      if method.to_s =~ /^max_unlocks_for_.+=$/
        test_class_name(class_name) rescue super
        self.max_unlocks_for(class_name, args[0])
      elsif method.to_s =~ /^max_unlocks_for_.+/
        test_class_name(class_name) rescue super
        self.unlock_limits.find_by_unlockable_type(class_name).limit
      elsif method.to_s =~ /_unlocks_remaining$/
        class_name = method.to_s.gsub(/_unlocks_remaining$/, '').gsub(/\W/, '').gsub('__', '::_').camelize
        test_class_name(class_name) rescue super
        unlocks_remaining_for_type(class_name)
      elsif method.to_s =~ /_unlocks_remaining\?$/
        class_name = method.to_s.gsub(/_unlocks_remaining\?$/, '').gsub(/\W/, '').gsub('__', '::_').camelize
        test_class_name(class_name) rescue super
        unlocks_remaining_for_type(class_name) > 0
      else
        super
      end
    end
    
    private
    
    def test_class_name(str)
      str.split('::').inject(Object) do |mod, class_name|
        mod.const_get(class_name) rescue raise NoMethodError
      end
    end
    
  end
    
  end
end

ActiveRecord::Base.send(:include, Acts::Unlocker)
