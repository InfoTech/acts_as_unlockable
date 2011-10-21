ACTS_AS_UNLOCKABLE = Gem::Specification.new do |s|
  s.name     = "acts_as_unlockable"
  s.version  = "1.0.4"
  s.date     = "2011-10-21"
  s.summary  = "Polymorphic unlock Rails gem - Rails 3+ only"
  s.email    = ""
  s.homepage = ""
  s.description = "Polymorphic unlock Rails gem for Rails 3+"
  s.authors  = ["Nick Neufeld", "Liam Nediger"]
  s.files    = `git ls-files`.split("\n")
  s.test_files = ["spec/unlockable_spec.rb", "spec/unlocker_spec.rb", "spec/spec_helper.rb", "spec/db/database.yml", "spec/db/schema.rb"]

  s.add_development_dependency 'rake'
  s.add_development_dependency 'bundler', '~> 1.0'
  s.add_development_dependency 'rspec', '~> 2.5'
  s.add_development_dependency 'sqlite3-ruby'
  s.add_development_dependency 'rails', '~> 3.0'

  s.add_dependency 'activerecord', '>= 3.0'
  s.add_dependency 'activesupport', '~> 3.0'
end
