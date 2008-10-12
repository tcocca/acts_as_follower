require 'acts_as_follower'
require 'acts_as_followable'
require 'follow.rb'

ActiveRecord::Base.send(:include, ActiveRecord::Acts::Follower)
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Followable)
