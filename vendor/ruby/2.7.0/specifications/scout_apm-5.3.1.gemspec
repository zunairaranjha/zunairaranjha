# -*- encoding: utf-8 -*-
# stub: scout_apm 5.3.1 ruby lib data
# stub: ext/allocations/extconf.rb ext/rusage/extconf.rb

Gem::Specification.new do |s|
  s.name = "scout_apm".freeze
  s.version = "5.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze, "data".freeze]
  s.authors = ["Derek Haynes".freeze, "Andre Lewis".freeze]
  s.date = "2022-08-18"
  s.description = "Monitors Ruby apps and reports detailed metrics on performance to Scout.".freeze
  s.email = ["support@scoutapp.com".freeze]
  s.extensions = ["ext/allocations/extconf.rb".freeze, "ext/rusage/extconf.rb".freeze]
  s.files = ["ext/allocations/extconf.rb".freeze, "ext/rusage/extconf.rb".freeze]
  s.homepage = "https://github.com/scoutapp/scout_apm_ruby".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.1".freeze)
  s.rubygems_version = "3.3.22".freeze
  s.summary = "Ruby application performance monitoring".freeze

  s.installed_by_version = "3.3.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
    s.add_development_dependency(%q<mocha>.freeze, [">= 0"])
    s.add_development_dependency(%q<pry>.freeze, [">= 0"])
    s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_development_dependency(%q<rake-compiler>.freeze, [">= 0"])
    s.add_development_dependency(%q<addressable>.freeze, [">= 0"])
    s.add_development_dependency(%q<activesupport>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<parser>.freeze, [">= 0"])
    s.add_development_dependency(%q<activerecord>.freeze, [">= 0"])
    s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_development_dependency(%q<rubocop>.freeze, [">= 0"])
    s.add_development_dependency(%q<guard>.freeze, [">= 0"])
    s.add_development_dependency(%q<guard-minitest>.freeze, [">= 0"])
    s.add_development_dependency(%q<m>.freeze, [">= 0"])
  else
    s.add_dependency(%q<minitest>.freeze, [">= 0"])
    s.add_dependency(%q<mocha>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<rake-compiler>.freeze, [">= 0"])
    s.add_dependency(%q<addressable>.freeze, [">= 0"])
    s.add_dependency(%q<activesupport>.freeze, [">= 0"])
    s.add_dependency(%q<parser>.freeze, [">= 0"])
    s.add_dependency(%q<activerecord>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_dependency(%q<rubocop>.freeze, [">= 0"])
    s.add_dependency(%q<guard>.freeze, [">= 0"])
    s.add_dependency(%q<guard-minitest>.freeze, [">= 0"])
    s.add_dependency(%q<m>.freeze, [">= 0"])
  end
end
