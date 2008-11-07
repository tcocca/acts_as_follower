require 'acts_as_follower'
require 'acts_as_followable'
require 'follow'

ActiveRecord::Base.send(:include, ActiveRecord::Acts::Follower)
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Followable)
