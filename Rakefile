begin
  require 'bundler/gem_tasks'
rescue LoadError
  warn 'You must `gem install bundler` and `bundle install` to run rake tasks'
  exit(1)
end

require 'rake/clean'
require 'rspec/core/rake_task'

# require 'spec'
# require 'spec/rake/spectask'
# Spec::Rake::SpecTask.new do |task|
#   task.libs << 'lib'
# end

# spec = Gem::Specification.load(FileList['*.gemspec'].first)

task :default => [:test, :install]

desc "Run all RSpec tests"
RSpec::Core::RakeTask.new(:spec)