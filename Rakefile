# encoding: UTF-8
require 'rubygems'
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rspec/core/rake_task'
desc 'Default: run specs.'
task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new do |t|
  t.pattern = "./spec/unit/*_spec.rb" # exclude integration specs
  # Put spec opts in a file named .rspec in root
end

desc "Run integration specs (make sure you have valid Salesforce login in spec_helper.rb)"
RSpec::Core::RakeTask.new(:integration) do |t|
  t.pattern = "./spec/integration/*_spec.rb" # run integration specs
end

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Salesforklift'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
