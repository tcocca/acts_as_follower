require File.dirname(__FILE__) + '/acts_as_follower/follower'
require File.dirname(__FILE__) + '/acts_as_follower/followable'
require File.dirname(__FILE__) + '/acts_as_follower/follower_lib'

ActiveRecord::Base.send(:include, ActsAsFollower::Follower)
ActiveRecord::Base.send(:include, ActsAsFollower::Followable)
