# -*- encoding: utf-8 -*-
# stub: countries 5.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "countries".freeze
  s.version = "5.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/countries/countries/issues", "changelog_uri" => "https://github.com/countries/countries/blob/master/CHANGELOG.md", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/countries/countries", "wiki_uri" => "https://github.com/countries/countries/wiki" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Josh Robinson".freeze, "Joe Corcoran".freeze, "Russell Osborne".freeze, "Pedro Moreira".freeze]
  s.date = "2022-08-11"
  s.description = "All sorts of useful information about every country packaged as pretty little country objects. It includes data from ISO 3166".freeze
  s.email = ["hexorx@gmail.com".freeze, "russell@burningpony.com".freeze, "pedro@codecreations.tech".freeze]
  s.homepage = "https://github.com/countries/countries".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7".freeze)
  s.rubygems_version = "3.3.22".freeze
  s.summary = "Gives you a country object full of all sorts of useful information.".freeze

  s.installed_by_version = "3.3.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<sixarm_ruby_unaccent>.freeze, ["~> 1.1"])
    s.add_development_dependency(%q<activesupport>.freeze, [">= 3"])
    s.add_development_dependency(%q<nokogiri>.freeze, [">= 1.8"])
    s.add_development_dependency(%q<rspec>.freeze, [">= 3"])
  else
    s.add_dependency(%q<sixarm_ruby_unaccent>.freeze, ["~> 1.1"])
    s.add_dependency(%q<activesupport>.freeze, [">= 3"])
    s.add_dependency(%q<nokogiri>.freeze, [">= 1.8"])
    s.add_dependency(%q<rspec>.freeze, [">= 3"])
  end
end
