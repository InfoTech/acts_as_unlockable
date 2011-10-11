require 'rubygems'
require 'rake/gempackagetask'
require 'spec'
require 'spec/rake/spectask'
require 'bundler/setup'

PLUGIN = "acts_as_unlockable"
NAME = "acts_as_unlockable"
GEM_VERSION = "1.0.0"
AUTHOR = "Info-Tech Research Group"
EMAIL = ""
SUMMARY = "Plugin/gem that provides unlocking functionality"

load 'acts_as_unlockable.gemspec'
spec = ACTS_AS_UNLOCKABLE

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**_spec.rb']
end

task :install => [:package] do
  sh %{sudo gem install pkg/#{NAME}-#{GEM_VERSION}}
end

task :default => :spec
