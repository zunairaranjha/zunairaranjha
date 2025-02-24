# -*- encoding: utf-8 -*-
# stub: request_store 1.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "request_store".freeze
  s.version = "1.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Steve Klabnik".freeze]
  s.date = "2019-12-20"
  s.description = "RequestStore gives you per-request global storage.".freeze
  s.email = ["steve@steveklabnik.com".freeze]
  s.homepage = "http://github.com/steveklabnik/request_store".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.3.22".freeze
  s.summary = "RequestStore gives you per-request global storage.".freeze

  s.installed_by_version = "3.3.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<rack>.freeze, [">= 1.4"])
    s.add_development_dependency(%q<rake>.freeze, ["~> 10.5"])
    s.add_development_dependency(%q<minitest>.freeze, ["~> 5.0"])
  else
    s.add_dependency(%q<rack>.freeze, [">= 1.4"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.5"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.0"])
  end
end
