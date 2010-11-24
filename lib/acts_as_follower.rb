%w( acts_as_follower/lib
    acts_as_follower/follower
    acts_as_follower/followable
).each do |lib|
    require File.join(File.dirname(__FILE__), lib)
end

ActiveRecord::Base.send(:include, ActsAsFollower::Follower)
ActiveRecord::Base.send(:include, ActsAsFollower::Followable)
