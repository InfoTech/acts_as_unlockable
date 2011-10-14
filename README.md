Acts As Unlockable
===================
Allows for models to unlock other models. Example: allow a user to unlock a piece of content as a part of a trial.


Requirements
------------



Install
-------

In your Gemfile, add
    gem 'acts_as_unlockable', :git => 'git://github.com/InfoTech/acts_as_unlockable.git'

and run `bundle install`.

Migrations
----------

* To install from scratch:

    `rails generate acts_as_unlockable_migration`

  This will generate the migration script necessary for the table


If the generators fail, you can just as easily create the migrations by hand. See the templates in the generators under `lib/generators`.

Usage
-----

###Basic Usage

To make a model unlockable:

    class Publication < ActiveRecord::Base
        acts_as_unlockable
    end

To give a model the ability to unlock:

    class User < ActiveRecord::Base
	    acts_as_unlocker
    end
    
Unlocking:

    u = User.create!
    pub = Publication.create!
    
    if u.can_unlock?(pub)
        u.unlock(pub)
    end

###Setting Unlock Limits
 
If you want to set globally applied unlock limits for an "Unlocker" Model:

    class User < ActiveRecord::Base
        acts_as_unlocker :limits => { :global => 10, :publication => 5, :video => 6}
    end
    
If you want to override the global limits for a particular unlocker:
    
    special_user = User.create!
    
    # drops the users global unlock limit to 5
    special_user.max_unlocks = 5 
    
    # drops the users unlock limit for Publications to 2
    special_user.max_unlocks_for_publication = 2 
