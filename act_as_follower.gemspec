# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "act_as_follower"
  s.version     = "1.0.0"
  s.authors     = ["Tom Cocca"]
  s.email       = ["unkown"]
  s.homepage    = ""
  s.summary     = %q{act_ast_follower gem}
  s.description = %q{act_ast_follower gem}

  # s.rubyforge_project = "act_as_follower"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
