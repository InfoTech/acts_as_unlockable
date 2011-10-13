require 'active_record'

require 'logger'

plugin_test_dir = File.dirname(__FILE__)

ActiveRecord::Base.logger = Logger.new(File.join(plugin_test_dir, "debug.log"))

ActiveRecord::Base.configurations = YAML::load_file(File.join(plugin_test_dir, "db", "database.yml"))
ActiveRecord::Base.establish_connection(ENV["DB"] || "sqlite3mem")
ActiveRecord::Migration.verbose = false
load(File.join(plugin_test_dir, "db", "schema.rb"))

require File.join(plugin_test_dir, '..', 'init')

class User < ActiveRecord::Base
  acts_as_unlocker
end

class Guest < ActiveRecord::Base
  acts_as_unlocker :limits => { :global => 2, :publication => 1 }
end

class Publication < ActiveRecord::Base
  acts_as_unlockable
end

class Video < ActiveRecord::Base
  acts_as_unlockable
end

ActiveRecord::Base.send(:include, Acts::Unlockable)
