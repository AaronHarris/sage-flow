# -*- encoding: utf-8 -*-

$LOAD_PATH << 'lib'

require 'sage_flow/version'

Gem::Specification.new do |s|
  s.name          = 'sage-flow'
  s.version       = SageFlow::VERSION
  s.author        = 'Francis Potter'
  s.email         = 'francis@hathersagegroup.com'
  s.summary       = 'Workflow system for Rails.'
  s.description   = %q{
    SageFlow adds standard workflow properties to Rails.
  }
  s.homepage      = 'https://github.com/hathersagegroup/sage-flow'
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path  = 'lib'
  
  s.add_dependency('activerecord', '>= 3.0.0')
  
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 2.0'
end