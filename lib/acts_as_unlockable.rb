$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'acts_as_unlockable/acts_as_unlockable'
require 'acts_as_unlockable/acts_as_unlocker'
require 'acts_as_unlockable/unlock'
require 'acts_as_unlockable/unlock_limit'
require 'acts_as_unlockable/exceptions'
$LOAD_PATH.shift
