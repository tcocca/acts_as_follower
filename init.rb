require File.dirname(__FILE__) + '/lib/acts_as_follower'
require File.dirname(__FILE__) + '/lib/acts_as_followable'
require File.dirname(__FILE__) + '/lib/follow'

ActiveRecord::Base.send(:include, ActiveRecord::Acts::Follower)
ActiveRecord::Base.send(:include, ActiveRecord::Acts::Followable)