# -*- encoding: utf-8 -*-
# stub: sprockets-es6 0.9.2 ruby lib

Gem::Specification.new do |s|
  s.name = "sprockets-es6".freeze
  s.version = "0.9.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Joshua Peek".freeze]
  s.date = "2016-09-23"
  s.description = "    A Sprockets transformer that converts ES6 code into vanilla ES5 with Babel JS.\n".freeze
  s.email = "josh@joshpeek.com".freeze
  s.homepage = "https://github.com/TannerRogalsky/sprockets-es6".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.3.22".freeze
  s.summary = "Sprockets ES6 transformer".freeze

  s.installed_by_version = "3.3.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<babel-transpiler>.freeze, [">= 0"])
    s.add_runtime_dependency(%q<babel-source>.freeze, [">= 5.8.11"])
    s.add_runtime_dependency(%q<sprockets>.freeze, [">= 3.0.0"])
    s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    s.add_development_dependency(%q<minitest>.freeze, [">= 0"])
  else
    s.add_dependency(%q<babel-transpiler>.freeze, [">= 0"])
    s.add_dependency(%q<babel-source>.freeze, [">= 5.8.11"])
    s.add_dependency(%q<sprockets>.freeze, [">= 3.0.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, [">= 0"])
  end
end
