require 'bundler'
require 'rake/testtask'

Bundler::GemHelper.install_tasks

namespace :test do
  Rake::TestTask.new('units') do |t|
    t.pattern = 'tests/*_test.rb'
  end
end

task :default => ['test:units']