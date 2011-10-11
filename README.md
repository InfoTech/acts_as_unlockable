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
    class Publication < ActiveRecord::Base
      acts_as_unlockable
    end
    
    class User < ActiveRecord::Base
    	acts_as_unlocker
    end
