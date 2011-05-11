$:.push File.expand_path("../lib", __FILE__)
require "markitup/version"

Gem::Specification.new do |s|
  s.name        = "markitup"
  s.version     = Markitup::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Phil Hofmann"]
  s.email       = ["phil@branch14.org"]
  s.homepage    = "http://branch14.org/markitup"
  s.summary     = %q{Rack Middleware to turn text areas into rich text editors}
  s.description = %q{Rack Middleware to turn text areas into rich text editors}

  # s.rubyforge_project = "markitup"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
