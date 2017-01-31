require "acts_as_follower/version"

module ActsAsFollower
  autoload :Follower,     'acts_as_follower/follower'
  autoload :Followable,   'acts_as_follower/followable'
  autoload :FollowerLib,  'acts_as_follower/follower_lib'
  autoload :FollowScopes, 'acts_as_follower/follow_scopes'

  require 'acts_as_follower/railtie' if defined?(Rails) && Rails::VERSION::MAJOR >= 3
end
