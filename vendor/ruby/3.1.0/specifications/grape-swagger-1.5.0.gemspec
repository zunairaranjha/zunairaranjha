# -*- encoding: utf-8 -*-
# stub: grape-swagger 1.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "grape-swagger".freeze
  s.version = "1.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["LeFnord".freeze, "Tim Vandecasteele".freeze]
  s.date = "2022-07-28"
  s.email = ["pscholz.le@gmail.com".freeze, "tim.vandecasteele@gmail.com".freeze]
  s.homepage = "https://github.com/ruby-grape/grape-swagger".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7".freeze)
  s.rubygems_version = "3.3.22".freeze
  s.summary = "Add auto generated documentation to your Grape API that can be displayed with Swagger.".freeze

  s.installed_by_version = "3.3.22" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4
  end

  if s.respond_to? :add_runtime_dependency then
    s.add_runtime_dependency(%q<grape>.freeze, ["~> 1.3"])
  else
    s.add_dependency(%q<grape>.freeze, ["~> 1.3"])
  end
end
