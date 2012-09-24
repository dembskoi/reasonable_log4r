$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "reasonable_log4r/version"

Gem::Specification.new do |s|
 s.name        = 'reasonable_log4r'
 s.version     = ReasonableLog4r::VERSION
 s.license     = 'New BSD License'
 s.date        = '2012-09-24'
 s.summary     = "Patches log4r gem to make it work in a reasonable way(Tm)."
 s.description = "Reasonable patches to log4r gem including root loggers having outputters and yaml configurator supporting many files and yaml sections."
 s.authors     = ["Keith Gabryelski"]
 s.email       = 'keith@fiksu.com'
 s.files       = `git ls-files`.split("\n")
 s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
 s.require_path = 'lib'
 s.homepage    = 'http://github.com/fiksu/reasonable_log4r'
 s.add_dependency 'log4r', '1.1.10'
 s.add_dependency "pg"
 s.add_dependency "rails", '>= 3.0.0'
 s.add_dependency 'rspec-rails'
end
