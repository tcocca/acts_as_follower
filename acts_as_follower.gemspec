# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "acts_as_follower/version"

Gem::Specification.new do |s|
  s.name        = "acts_as_follower"
  s.version     = ActsAsFollower::VERSION
  s.authors     = ["Tom Cocca"]
  s.email       = ["tom dot cocca at gmail dot com"]
  s.homepage    = "https://github.com/tcocca/acts_as_follower"
  s.summary     = %q{A Rubygem to add Follow functionality for ActiveRecord models}
  s.description = %q{acts_as_follower is a Rubygem to allow any model to follow any other model. This is accomplished through a double polymorphic relationship on the Follow model. There is also built in support for blocking/un-blocking follow records. Main uses would be for Users to follow other Users or for Users to follow Books, etc… (Basically, to develop the type of follow system that GitHub has)}
  s.license     = 'MIT'

  s.rubyforge_project = "acts_as_follower"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'activerecord', '>= 4.0'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "shoulda_create"
  s.add_development_dependency "shoulda", ">= 3.5.0"
  s.add_development_dependency "factory_girl", ">= 4.2.0"
  s.add_development_dependency "rails", ">= 4.0"
end
