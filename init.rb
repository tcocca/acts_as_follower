require 'lib/acts_as_follower'
require 'lib/acts_as_followable'
require 'lib/follow'

ActiveRecord::Base.send(:include, ActiveRecord::Acts::Follower)
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Followable)
